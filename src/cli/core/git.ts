import { cmd } from "denox/shell/mod.ts";

export async function configure(opts: { [key: string]: string }) {
  for (const k of Object.keys(opts)) {
    await cmd(["git", "config", "--global", k, opts[k]]);
  }
}
