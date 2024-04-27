import { cmd } from "denox/shell/mod.ts";

export async function getDebianVersion() {
  try {
    return await cmd(["lsb_release", "-cs"], { stdout: "piped" })
      .then((r) => r.output())
      .then((r) => r.trim().replace("\n", ""));
  } catch (_) {
    return null;
  }
}

export async function getDpkgArch() {
  try {
    return await cmd(["dpkg", "--print-architecture"], { stdout: "piped" })
      .then((r) => r.output())
      .then((r) => r.trim().replace("\n", ""));
  } catch (_) {
    return null;
  }
}
