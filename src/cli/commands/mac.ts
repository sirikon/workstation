import { CommandGroupBuilder } from "denox/ui/cli/commandGroup.ts";
import { cmd } from "denox/shell/mod.ts";
import { localConfig } from "../core/config.ts";

export const macCommand = (srk: CommandGroupBuilder) => {
  const mac = srk.group("mac");

  mac.command("set-global-env")
    .description(
      "Runs launchctl setenv with each defined envvar in ~/.srk.json",
    )
    .action(() => {
      for (const key of Object.keys(localConfig.environment)) {
        cmd(["launchctl", "setenv", key, localConfig.environment[key]]);
      }
    });
};
