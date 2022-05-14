import { bash } from "denox/shell/mod.ts";

export async function homeDir() {
  const res = await bash(`printf "%s" ~`, { stdout: "piped" });
  if (res.success) {
    return (await res.output()).trim();
  }
  throw new Error("Could not retrieve user home directory", {
    cause: res.error,
  });
}
