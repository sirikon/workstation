import { cmd } from "denox/shell/mod.ts";

export async function ensure(...packages: string[]) {
  await cmd(["brew", "install", "--quiet", ...packages]);
}
