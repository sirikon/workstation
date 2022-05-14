import { CommandGroupBuilder } from "denox/ui/cli/commandGroup.ts";
import { cmd } from "denox/shell/mod.ts";
import { config } from "../core/config.ts";

export const macCommand = (srk: CommandGroupBuilder) => {
  const mac = srk.group("mac");

  mac.command("set-global-env")
    .description(
      "Runs launchctl setenv with each defined envvar in ~/.srk.json",
    )
    .action(() => {
      for (const key of Object.keys(config.environment)) {
        cmd(["launchctl", "setenv", key, config.environment[key]]);
      }
    });
};
