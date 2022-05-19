import * as paths from "../core/paths.ts";
import { join } from "std/path/mod.ts";
import { Config } from "../core/config.ts";
import { readFile } from "denox/fs/mod.ts";
import { ensureSymlink } from "std/fs/mod.ts";

type ArrayElement<ArrayType extends readonly unknown[]> = ArrayType extends readonly (infer ElementType)[] ? ElementType : never;

export async function apply(links: Config["links"]) {
  for (const link of links) {
    const sourcePath = await getSourcePath(link.to);
    const destinationPath = await getDestinationPath(link.from);
    if (sourcePath == null || destinationPath == null) continue;

    await ensureSymlink(sourcePath, destinationPath);
  }
}

export async function getDestinationPath(from: ArrayElement<Config["links"]>["from"]) {
  if (Deno.build.os === "darwin") {
    return from.darwin ? expandPath(from.darwin) : null;
  }
  if (Deno.build.os === "linux") {
    return from.linux ? expandPath(from.linux) : null;
  }
  return null;
}

export async function getSourcePath(to: ArrayElement<Config["links"]>["to"]) {
  const [type, path] = to;
  if (type === "config") {
    return join(await paths.homeDir(), ".srk", "src", "config", path);
  }
  if (type === "dropbox") {
    const dropboxRootPath = await getDropboxRootPath();
    if (!dropboxRootPath) return null;
    return join(dropboxRootPath, path);
  }
  ((x: never) => {})(type);
  return null;
}

async function expandPath(path: string) {
  return path.replace(/^~/, await paths.homeDir());
}

async function getDropboxRootPath() {
  if (Deno.build.os === "darwin") {
    const contents = JSON.parse(
      await readFile(
        join(await paths.homeDir(), ".dropbox", "info.json"),
      ),
    ) as { personal: { path: string } };

    return contents.personal.path;
  }
  return null;
}
