import { cmd } from "denox/shell/mod.ts";

export async function ensurePackages(...packages: string[]) {
  await cmd(["apt-get", "install", "-y", ...packages]);
}
