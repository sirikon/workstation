import { cli, run } from "denox/ui/cli/mod.ts";
import { installCommand } from "./commands/install.ts";
import { macCommand } from "./commands/mac.ts";

const srk = cli("srk");

installCommand(srk);
macCommand(srk);

run(srk);
