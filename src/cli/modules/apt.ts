import { cmd } from "denox/shell/mod.ts";

export async function ensurePackages(...packages: string[]) {
  await cmd(["sudo", "apt-get", "install", "-y", ...packages]);
}
