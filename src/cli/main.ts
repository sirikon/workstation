import { cli, run } from "denox/ui/cli/mod.ts";
import { installCommand } from "$/commands/install.ts";
import { firefoxCommand } from "$/commands/firefox.ts";

const srk = cli("srk");

installCommand(srk);
firefoxCommand(srk);

run(srk);
