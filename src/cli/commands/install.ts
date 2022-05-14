import * as log from "../core/logging.ts";
import * as brew from "../modules/brew.ts";
import * as git from "../modules/git.ts";
import * as asdf from "../modules/asdf.ts";
import * as dropbox from "../modules/dropbox.ts";
import * as paths from "../core/paths.ts";
import { extendFile } from "../core/fs.ts";
import { ensureDir } from "std/fs/mod.ts";
import { join } from "std/path/mod.ts";
import { CommandGroupBuilder } from "denox/ui/cli/commandGroup.ts";
import { config } from "../core/config.ts";

export const installCommand = (srk: CommandGroupBuilder) => {
  srk.command("install")
    .description("runs installation")
    .action(async () => {
      if (Deno.build.os === "darwin") {
        log.title("Ensuring brew is installed");
        await brew.ensureBrew();
        log.title("Ensuring brew dependencies");
        await brew.ensurePackages("coreutils", "bash", "jq", "git");
      }

      log.title("Configuring git");
      await git.configure({
        "pull.rebase": "true",
        "submodule.recurse": "true",
        "user.name": "Carlos Fdez. Llamas",
        "user.email": "hello@sirikon.me",
      });

      log.title("Ensuring asdf is installed and updated");
      await asdf.ensureAsdf();
      log.title("Configuring asdf");
      await asdf.writeAsdfrc([
        "legacy_version_file = yes",
        "",
      ]);

      log.title("Extending ~/.bash_profile");
      await extendFile({
        file: join(await paths.homeDir(), ".bash_profile"),
        prefix: "### srk",
        suffix: "### /srk",
        data: [
          ...Object.keys(config.environment)
            .map((k) => `export ${k}="${config.environment[k]}"`),
          "",
          ...(Deno.build.os === "linux"
            ? ["source ~/.srk/src/shell/activate.linux.sh"]
            : []),
          ...(Deno.build.os === "darwin"
            ? ["source ~/.srk/src/shell/activate.mac.sh"]
            : []),
          "source ~/.srk/src/shell/activate.sh",
        ],
      });

      log.title("Ensure ~/bin folder");
      await ensureDir(join(await paths.homeDir(), "bin"));

      log.title("Linking Dropbox to applications");
      await dropbox.link([
        {
          dropbox: "ProgramData/DBeaver/General",
          darwin: join(
            await paths.homeDir(),
            "Library/DBeaverData/workspace6/General",
          ),
        },
        {
          dropbox: "ProgramData/MacOsTerminal/com.apple.Terminal.plist",
          darwin: join(
            await paths.homeDir(),
            "Library/Preferences/com.apple.Terminal.plist",
          )
        }
      ]);
    });
};
