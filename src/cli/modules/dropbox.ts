import { readFile } from "denox/fs/mod.ts";
import { join } from "std/path/mod.ts";
import { ensureSymlink, exists } from "std/fs/mod.ts";
import * as paths from "../core/paths.ts";

export type DropboxLinkOpts = {
  dropbox: string;
  darwin?: string;
};

export async function link(links: DropboxLinkOpts[]) {
  const dropboxRoot = await getDropboxRootPath();
  if (!dropboxRoot) {
    throw new Error("Could not find Dropbox root path. Is it installed?");
  }
  for (const link of links) {
    const localPath = (() => {
      if (Deno.build.os === "darwin") return link.darwin || null;
      return null;
    })();
    if (!localPath) return;

    const dropboxPath = join(dropboxRoot, link.dropbox);
    if (!(await Deno.stat(join(dropboxRoot, link.dropbox))).isDirectory) {
      throw new Error(`${join(dropboxRoot, link.dropbox)} is not a directory`);
    }

    if (await exists(localPath)) {
      await Deno.remove(localPath, { recursive: true });
    }
    await ensureSymlink(dropboxPath, localPath);
    console.log(`${dropboxPath} -> ${localPath}`);
  }
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
