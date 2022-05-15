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
import { config, localConfig } from "../core/config.ts";

export const installCommand = (srk: CommandGroupBuilder) => {
  srk.command("install")
    .description("runs installation")
    .action(async () => {
      if (Deno.build.os === "darwin") {
        log.title("Ensuring brew is installed");
        await brew.ensureBrew();
        log.title("Ensuring brew dependencies");
        await brew.ensurePackages(...config.brew.packages);
      }

      log.title("Configuring git");
      await git.configure({
        "pull.rebase": "true",
        "submodule.recurse": "true",
        "user.name": config.git.name,
        "user.email": config.git.email,
      });

      log.title("Ensuring asdf is installed and updated");
      await asdf.ensureAsdf();
      log.title("Configuring asdf");
      await asdf.writeAsdfrc([
        ...Object.entries(config.asdf.config).map(([k, v]) => `${k} = ${v}`),
        "",
      ]);

      log.title("Extending ~/.bash_profile");
      await extendFile({
        file: join(await paths.homeDir(), ".bash_profile"),
        prefix: "### srk",
        suffix: "### /srk",
        data: [
          ...Object.keys(localConfig.environment)
            .map((k) => `export ${k}="${localConfig.environment[k]}"`),
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
      const homeDir = await paths.homeDir();
      await dropbox.link(
        config.dropbox.links.map((l) => ({
          ...l,
          darwin: l.darwin ? l.darwin.replace(/^~/g, homeDir) : undefined,
        })),
      );
    });
};
