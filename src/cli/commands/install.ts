import * as log from "$/core/logging.ts";
import * as brew from "$/modules/brew.ts";
import * as apt from "$/modules/apt.ts";
import * as devices from "$/modules/devices.ts";
import * as git from "$/modules/git.ts";
import * as asdf from "$/modules/asdf.ts";
import * as paths from "$/core/paths.ts";
import * as links from "$/modules/links.ts";
import { extendFile } from "$/core/fs.ts";
import { ensureDir, exists } from "std/fs/mod.ts";
import { dirname, join } from "std/path/mod.ts";
import { CommandGroupBuilder } from "denox/ui/cli/commandGroup.ts";
import { localConfig } from "$/core/config.ts";
import config from "$/config.ts";
import { writeFile } from "denox/fs/mod.ts";
import { bash, cmd } from "denox/shell/mod.ts";

export const installCommand = (srk: CommandGroupBuilder) => {
  srk.command("install")
    .description("runs installation")
    .action(async () => {
      if (Deno.build.os === "darwin") {
        log.title("Ensuring brew is installed");
        await brew.ensureBrew();
        log.title("Ensuring brew dependencies");
        await brew.ensureFormulae(...config.brew.formulae);
        await brew.ensureCasks(...config.brew.casks);
      }

      if (Deno.build.os === "linux") {
        log.title("Ensuring base apt packages");
        await apt.ensurePackages(
          "apt-transport-https",
          "ca-certificates",
          "curl",
          "git",
          "gnupg",
          "lsb-release",
          "debian-archive-keyring",
        );
        log.title("Configuring apt repositories");
        await apt.setRepositories(config.apt.repositories);
        log.title("Configuring apt pins");
        await apt.setPins(config.apt.pins);
        log.title("Ensuring all required apt packages");
        await apt.ensurePackages(
          ...(await devices.getRequiredAptPackages()),
          ...config.apt.packages,
        );

        log.title("Configure docker user");
        await bash(`
          sudo groupadd docker 2>/dev/null
          sudo usermod -aG docker "$USER"
        `);

        log.title("Configure networking");
        await bash(`
          sudo systemctl disable systemd-networkd systemd-networkd.socket systemd-networkd-wait-online
          sudo systemctl stop systemd-networkd systemd-networkd.socket systemd-networkd-wait-online
        
          sudo systemctl disable systemd-resolved
          sudo systemctl stop systemd-resolved
        
          sudo rm -f /etc/network/interfaces
        
          sudo systemctl enable NetworkManager
          sudo systemctl start NetworkManager
        `);

        log.title("Extending .profile");
        await extendFile({
          file: join(await paths.homeDir(), ".profile"),
          prefix: "### srk",
          suffix: "### /srk",
          data: [
            ...Object.keys(localConfig.environment)
              .map((k) => `export ${k}="${localConfig.environment[k]}"`),
            ...(Object.keys(localConfig.environment).length > 0 ? [""] : []),
            `PATH="$HOME/.srk/src/bin:$PATH"`,
          ],
        });

        log.title("Configuring graphics cards for X11");
        await devices.configureXorgGraphicsCard();

        log.title("Configuring event hook for NetworkManager and i3blocks network information");
        const scriptPath = join(await paths.homeDir(), ".srk", "src", "config", "i3blocks", "refresh-i3blocks-netinfo");
        const tempFilePath = join(await paths.homeDir(), ".srk", "temp", "srk-i3blocks-hook");
        await ensureDir(dirname(tempFilePath));
        await writeFile(tempFilePath, [
          "#!/usr/bin/env bash",
          "set -euo pipefail",
          scriptPath,
          "",
        ]);
        await cmd(["sudo", "mv", tempFilePath, "/etc/NetworkManager/dispatcher.d/srk-i3blocks-hook"]);
        await cmd(["sudo", "chown", "root:root", "/etc/NetworkManager/dispatcher.d/srk-i3blocks-hook"]);
        await cmd(["sudo", "chmod", "+x", "/etc/NetworkManager/dispatcher.d/srk-i3blocks-hook"]);

        log.title("Setting default apps");
        await cmd(["xdg-mime", "default", "thunar.desktop", "inode/directory"]);
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

      const bashFiles = (await Promise.all([
        join(await paths.homeDir(), ".bash_profile"),
        join(await paths.homeDir(), ".bashrc"),
      ].map((f) => exists(f).then((e) => [f, e] as const))))
        .filter(([_, e]) => e)
        .map(([f]) => f);

      const bashFile = bashFiles.length > 0 ? bashFiles[0] : null;

      if (bashFile == null) {
        console.log("No bash file found to extend");
        Deno.exit(1);
      }

      log.title("Extending " + bashFile);
      await extendFile({
        file: bashFile,
        prefix: "### srk",
        suffix: "### /srk",
        data: [
          ...Object.keys(localConfig.environment)
            .map((k) => `export ${k}="${localConfig.environment[k]}"`),
          ...(Object.keys(localConfig.environment).length > 0 ? [""] : []),
          ...(Deno.build.os === "linux" ? ["source ~/.srk/src/shell/activate.linux.sh"] : []),
          ...(Deno.build.os === "darwin" ? ["source ~/.srk/src/shell/activate.mac.sh"] : []),
          "source ~/.srk/src/shell/activate.sh",
        ],
      });

      log.title("Ensure ~/bin folder");
      await ensureDir(join(await paths.homeDir(), "bin"));

      log.title("Linking files");
      await links.apply(config.links);
    });
};
