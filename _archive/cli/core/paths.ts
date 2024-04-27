import { bash } from "denox/shell/mod.ts";

export async function homeDir() {
  return await bash(`printf "%s" ~`, { stdout: "piped" })
    .then((r) => r.output())
    .then((r) => r.trim());
}
