import * as log from "./core/logging.ts";
import { cli, run } from "denox/ui/cli/mod.ts";

const srk = cli("srk");

srk.command("install")
  .description("runs installation")
  .action(() => {
    log.info("Install!")
  })

run(srk)
