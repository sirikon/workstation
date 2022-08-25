import { cli, run } from "denox/ui/cli/mod.ts";
import { installCommand } from "$/commands/install.ts";

const srk = cli("srk");

installCommand(srk);

run(srk);
