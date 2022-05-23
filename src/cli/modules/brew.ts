import { bash, cmd } from "denox/shell/mod.ts";

export async function ensureBrew() {
  try {
    await Deno.stat("/opt/homebrew/bin/brew");
  } catch (err: unknown) {
    if (err instanceof Deno.errors.NotFound) {
      await bash(
        `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`,
      );
      return;
    }
    throw err;
  }
}

export async function ensureFormulae(...formulae: string[]) {
  const installedFormulae = await getInstalledPackages("formulae");
  const formulaeToInstall = formulae.filter((f) => installedFormulae.indexOf(f) === -1);
  if (formulaeToInstall.length === 0) return;

  await cmd(["/opt/homebrew/bin/brew", "install", "--formulae", "--quiet", ...formulaeToInstall]);
}

export async function ensureCasks(...casks: string[]) {
  const installedCasks = await getInstalledPackages("casks");
  const casksToInstall = casks.filter((c) => installedCasks.indexOf(c) === -1);
  if (casksToInstall.length === 0) return;

  await cmd(["/opt/homebrew/bin/brew", "install", "--casks", "--quiet", ...casksToInstall]);
}

export async function getInstalledPackages(kind: "formulae" | "casks") {
  const result = await cmd(["/opt/homebrew/bin/brew", "list", "--" + kind, "-1"], { stdout: "piped" });
  if (!result.success) {
    throw result.error;
  }
  const output = await result.output();
  return output.trim().split("\n").map((l) => l.trim());
}
