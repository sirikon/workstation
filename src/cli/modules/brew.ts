import { bash, cmd } from "denox/shell/mod.ts";

export async function ensureBrew() {
  try {
    await Deno.stat("/opt/homebrew/bin/brew");
  } catch (err: unknown) {
    if (err instanceof Deno.errors.NotFound) {
      await bash(
        `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`,
      );
      return;
    }
    throw err;
  }
}

export async function ensurePackages(...packages: string[]) {
  await cmd(["brew", "install", "--quiet", ...packages]);
}
