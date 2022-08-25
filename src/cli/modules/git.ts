import { cmd } from "denox/shell/mod.ts";
import * as log from "$/core/logging.ts";

export async function configure(opts: { [key: string]: string }) {
  for (const k of Object.keys(opts)) {
    const command = ["git", "config", "--global", k, opts[k]];
    log.info(command.join(" "));
    await cmd(command);
  }
}
