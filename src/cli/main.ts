import * as log from "./core/logging.ts";
import * as brew from "./core/brew.ts";
import * as git from "./core/git.ts";
import { cli, run } from "denox/ui/cli/mod.ts";

const srk = cli("srk");

srk.command("install")
  .description("runs installation")
  .action(async () => {
    if (Deno.build.os === "darwin") {
      log.title("Installing brew dependencies");
      await brew.ensure("coreutils", "bash", "jq", "git");
    }

    log.title("Configuring git");
    await git.configure({
      "pull.rebase": "true",
      "submodule.recurse": "true",
      "user.name": "Carlos Fdez. Llamas",
      "user.email": "hello@sirikon.me",
    });
  });

run(srk);
