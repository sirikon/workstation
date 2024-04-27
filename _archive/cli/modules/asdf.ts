import * as paths from "$/core/paths.ts";
import { bash } from "denox/shell/mod.ts";
import { writeFile } from "denox/fs/mod.ts";
import { join } from "std/path/mod.ts";

export async function ensureAsdf() {
  try {
    if (!(await Deno.stat(join(await paths.homeDir(), ".asdf"))).isDirectory) {
      throw new Error(
        ".asdf exists on home directory, but it's not a directory",
      );
    }
  } catch (err: unknown) {
    if (err instanceof Deno.errors.NotFound) {
      await bash(
        "git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.0",
      );
      return;
    }
    throw err;
  }
}

export async function updateAsdf() {
  await bash("~/.asdf/bin/asdf update");
}

export async function writeAsdfrc(lines: string[]) {
  await writeFile(join(await paths.homeDir(), ".asdfrc"), lines);
}
