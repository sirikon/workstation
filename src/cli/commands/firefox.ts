import { CommandGroupBuilder } from "denox/ui/cli/commandGroup.ts";
import { writeFile } from "denox/fs/mod.ts";
import { join } from "std/path/mod.ts";
import { parseIni } from "$/core/ini.ts";
import { homeDir } from "$/core/paths.ts";

export const firefoxCommand = (srk: CommandGroupBuilder) => {
  const firefox = srk.group("firefox");
  firefox
    .command("configure")
    .description("creates user.js file for config")
    .action(async () => {
      const firefoxInstalls = await getFirefoxInstalls();
      const lastFirefoxInstall = firefoxInstalls[firefoxInstalls.length - 1];

      await setFirefoxSettings(lastFirefoxInstall.defaultProfile, {
        "layers.acceleration.force-enabled": true,
        "gfx.webrender.all": true,
        "media.ffmpeg.vaapi.enabled": true,
      });
    });
};

const setFirefoxSettings = async (profile: string, settings: Record<string, unknown>) => {
  await writeFile(
    join(await homeDir(), ".mozilla", "firefox", profile, "user.js"),
    [
      ...Object.entries(settings).map(([key, value]) => `user_pref(${JSON.stringify(key)}, ${JSON.stringify(value)});`),
      "",
    ],
  );
};

const getFirefoxInstalls = async () => {
  const installsIni = await Deno.readTextFile(join(await homeDir(), ".mozilla", "firefox", "installs.ini"));
  return parseIni(installsIni).map((item) => ({
    id: item.section,
    defaultProfile: item.data["Default"],
    locked: item.data["Locked"] === "1",
  }));
};
