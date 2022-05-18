import * as paths from "../core/paths.ts";
import { bash, cmd } from "denox/shell/mod.ts";
import { readFile, writeFile } from "denox/fs/mod.ts";
import { ensureDir, exists } from "std/fs/mod.ts";
import { Config } from "../core/config.ts";
import { dirname, join } from "std/path/mod.ts";

type ArrayElement<ArrayType extends readonly unknown[]> = ArrayType extends readonly (infer ElementType)[] ? ElementType : never;

export async function ensurePackages(...packages: string[]) {
  const installedPackages = await getInstalledPackages();
  const packagesToInstall = packages.filter((p) => installedPackages.indexOf(p) === -1);
  if (packagesToInstall.length === 0) return;
  await cmd(["sudo", "apt-get", "install", "-y", ...packagesToInstall]);
}

export async function setRepositories(repositories: Config["apt"]["repositories"]) {
  for (const repository of repositories) {
    await ensureKeyring(repository);
  }

  const tempFilePath = join(await paths.homeDir(), ".srk", "temp", "sirikon.list");
  await ensureDir(dirname(tempFilePath));
  await writeFile(tempFilePath, [
    ...repositories.map((r) => {
      const [kind, url, areas, opts] = r;
      const keyringPath = opts?.key ? `/usr/share/keyrings/${opts.key[0]}-archive-keyring.gpg` : null;

      const params = [
        ...(opts?.trusted ? ["trusted=yes"] : []),
        ...(opts?.arch ? ["arch=" + opts.arch] : []),
        ...(keyringPath != null ? ["signed-by=" + keyringPath] : []),
      ];
      const paramsChunk = params.length > 0 ? ` [${params.join(" ")}] ` : " ";

      return `${kind}${paramsChunk}${url} ${areas.join(" ")}`;
    }),
    "",
  ]);

  const updateAfterWrite = (await readFile(tempFilePath)) !== (await readFile("/etc/apt/sources.list.d/sirikon.list"));
  await cmd(["sudo", "mv", tempFilePath, "/etc/apt/sources.list.d/sirikon.list"]);
  updateAfterWrite && await cmd(["sudo", "apt-get", "update"]);
}

export async function setPins(pins: Config["apt"]["pins"]) {
  const tempFilePath = join(await paths.homeDir(), ".srk", "temp", "sirikon.pins");
  await ensureDir(dirname(tempFilePath));
  await writeFile(tempFilePath, [
    ...pins.map(([packageName, release, priority]) =>
      [
        "Package: " + packageName,
        "Pin: release " + release,
        "Pin-Priority: " + priority.toString(),
        "",
      ].join("\n")
    ),
    "",
  ]);
  await cmd(["sudo", "mv", tempFilePath, "/etc/apt/preferences.d/99sirikon"]);
}

async function ensureKeyring(repository: ArrayElement<Config["apt"]["repositories"]>) {
  if (!repository[3]?.key) return;

  const [name, url] = repository[3].key;
  const localPath = `/usr/share/keyrings/${name}-archive-keyring.gpg`;
  if (await exists(localPath)) return;

  console.log(`Installing keyring ${name}`);
  await bash(`curl -fsSL "${url}" | sudo gpg --dearmor -o "${localPath}"`);
}

async function getInstalledPackages() {
  const result = await cmd(["bash", "-c", "dpkg --get-selections | grep -v deinstall"], { stdout: "piped" });
  if (!result.success) {
    throw result.error;
  }
  const output = await result.output();
  return output.trim().split("\n").map((l) => l.split("\t")[0]);
}
