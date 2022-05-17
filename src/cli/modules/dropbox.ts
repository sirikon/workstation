import { readFile } from "denox/fs/mod.ts";
import { join } from "std/path/mod.ts";
import { ensureLink, ensureSymlink, exists } from "std/fs/mod.ts";
import * as paths from "../core/paths.ts";

export type DropboxLinkOpts = {
  dropbox: string;
  darwin?: string;
};

export async function link(links: DropboxLinkOpts[]) {
  const dropboxRoot = await getDropboxRootPath();
  if (!dropboxRoot) {
    console.log("Could not find Dropbox root path. Is it installed?");
    return;
  }
  for (const link of links) {
    const localPath = (() => {
      if (Deno.build.os === "darwin") return link.darwin || null;
      return null;
    })();
    if (!localPath) return;

    const dropboxPath = join(dropboxRoot, link.dropbox);
    if (!await exists(dropboxPath)) {
      throw new Error(`${dropboxPath} does not exist`);
    }
    if (await exists(localPath)) {
      await Deno.remove(localPath, { recursive: true });
    }

    const useSoftLink = (await Deno.stat(dropboxPath)).isDirectory;

    useSoftLink
      ? await ensureSymlink(dropboxPath, localPath)
      : await ensureLink(dropboxPath, localPath);

    console.log(`[${useSoftLink ? "S" : "H"}] ${localPath}\n    ${dropboxPath}`);
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
