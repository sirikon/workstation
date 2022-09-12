import { CommandGroupBuilder } from "denox/ui/cli/commandGroup.ts";

export const firefoxCommand = (srk: CommandGroupBuilder) => {
  const firefox = srk.group("firefox");
  firefox
    .command("configure")
    .description("manages current firefox profile and ensures to be configured properly")
    .action(() => {
      console.log("Soon TM");
    });
};
