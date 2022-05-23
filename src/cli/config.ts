import { cmd } from "denox/shell/mod.ts";
import { Config } from "./core/config.ts";

const debianVersion = await getDebianVersion();
const dpkgArch = await getDpkgArch();

const config: Config = {
  git: {
    name: "Carlos Fdez. Llamas",
    email: "hello@sirikon.me",
  },
  brew: {
    formulae: ["coreutils", "bash", "jq", "git"],
    casks: [
      "dropbox",
      "slack",
      "firefox",
      "discord",
      "docker",
      "dbeaver-community",
      "keepassxc",
      "visual-studio-code",
      "sublime-merge",
      "telegram-desktop",
      "jetbrains-toolbox",
    ],
  },
  apt: {
    repositories: !(debianVersion && dpkgArch) ? [] : [
      ["deb", "http://deb.debian.org/debian", [debianVersion, "contrib", "non-free"]],
      ["deb-src", "http://deb.debian.org/debian", [debianVersion, "contrib", "non-free"]],
      ["deb", "http://deb.debian.org/debian-security/", [`${debianVersion}-security`, "contrib", "non-free"]],
      ["deb-src", "http://deb.debian.org/debian-security/", [`${debianVersion}-security`, "contrib", "non-free"]],
      ["deb", "http://deb.debian.org/debian", ["buster", "main"]],
      ["deb-src", "http://deb.debian.org/debian", ["buster", "main"]],
      ["deb", "https://dbeaver.io/debs/dbeaver-ce", ["/"], {
        key: ["dbeaver", "https://dbeaver.io/debs/dbeaver.gpg.key"],
      }],
      ["deb", "https://download.sublimetext.com/", ["apt/stable/"], {
        key: ["sublimehq", "https://download.sublimetext.com/sublimehq-pub.gpg"],
      }],
      ["deb", "https://download.docker.com/linux/debian", [debianVersion, "stable"], {
        key: ["docker", "https://download.docker.com/linux/debian/gpg"],
        arch: dpkgArch,
      }],
      ["deb", "https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs", ["vscodium", "main"], {
        key: ["vscodium", "https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg"],
      }],
      ["deb", "http://repository.spotify.com", ["stable", "non-free"], {
        key: ["spotify-5E3C45D7B312C643", "https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg"],
      }],
      ["deb", "https://download.virtualbox.org/virtualbox/debian", [debianVersion, "contrib"], {
        key: ["virtualbox", "https://www.virtualbox.org/download/oracle_vbox_2016.asc"],
        arch: dpkgArch,
      }],
      // ["deb", "https://download.konghq.com/insomnia-ubuntu/", ["default", "all"], {
      //   arch: dpkgArch,
      //   trusted: true,
      // }],
    ],
    pins: [
      ["*", "o=Debian,n=buster", 1],
      ["*", "o=packagecloud.io/slacktechnologies/slack", 1],
      // ["*", "l=insomnia-ubuntu", 1],
    ],
    packages: [
      "xorg",
      "i3",
      "lightdm",
      "network-manager",
      "network-manager-gnome",
      "chromium",
      "vim",
      "arandr",
      "pulseaudio",
      "pavucontrol",
      "spotify-client",
      "nitrogen",
      "dunst",
      "thunar",
      "gnome-calculator",
      "python3",
      "python3-pip",
      "python3-venv",
      "python3-gpg",
      "fwupd",
      "policykit-1-gnome",
      "fonts-noto-color-emoji",
      "linux-headers-amd64",
      "i3blocks",
      "vlc",
      "gpicview",
      "libnotify-bin",
      "xfce4-terminal",
      "jq",
      "qbittorrent",
      "maim",
      "blueman",
      "codium",
      // "insomnia",
      "xclip",
      "xz-utils",
      "keepassxc",
      "docker-ce",
      "docker-ce-cli",
      "containerd.io",
      "dbeaver-ce",
      "sublime-text",
      "sublime-merge",
      "zenity",
      "xss-lock",
      "virtualbox-6.1",
      "zip",
      "unzip",
      "cups",
      "system-config-printer",
      "gnome-system-monitor",
      "brightnessctl",
    ],
  },
  asdf: {
    config: {
      "legacy_version_file": "yes",
    },
  },
  links: [
    {
      from: {
        linux: "~/.local/share/DBeaverData/workspace6/General",
        darwin: "~/Library/DBeaverData/workspace6/General",
      },
      to: ["dropbox", "ProgramData/DBeaver/General"],
    },
    {
      from: { linux: "~/.local/share/data/qBittorrent/BT_backup" },
      to: ["dropbox", "ProgramData/qBittorrent/BT_backup"],
    },
    {
      from: { linux: "~/.config/i3" },
      to: ["config", "i3"],
    },
    {
      from: { linux: "~/.config/i3blocks" },
      to: ["config", "i3blocks"],
    },
    {
      from: {
        linux: "~/.config/VSCodium/User/settings.json",
        darwin: "~/Library/Application Support/Code/User/settings.json",
      },
      to: ["config", "vscode/settings.json"],
    },
    {
      from: { linux: "~/.config/xfce4/terminal/terminalrc" },
      to: ["config", "xfce4-terminal/terminalrc"],
    },
    {
      from: { linux: "~/.config/sublime-text/Packages/User/Preferences.sublime-settings" },
      to: ["config", "sublime-text/Preferences.sublime-settings"],
    },
    {
      from: { linux: "~/.config/sublime-merge/Packages/User/Preferences.sublime-settings" },
      to: ["config", "sublime-merge/Preferences.sublime-settings"],
    },
    {
      from: { linux: "~/.Xresources" },
      to: ["config", "x/Xresources"],
    },
    {
      from: { linux: "~/.xsessionrc" },
      to: ["config", "x/xsessionrc"],
    },
  ],
};

async function getDebianVersion() {
  try {
    const result = await cmd(["lsb_release", "-cs"], { stdout: "piped" });
    if (!result.success) return null;
    return (await result.output()).trim().replace("\n", "");
  } catch (err) {
    return null;
  }
}

async function getDpkgArch() {
  try {
    const result = await cmd(["dpkg", "--print-architecture"], { stdout: "piped" });
    if (!result.success) return null;
    return (await result.output()).trim().replace("\n", "");
  } catch (err) {
    return null;
  }
}

export default config;
