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
    packages: ["coreutils", "bash", "jq", "git"],
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
      ["deb", "https://download.konghq.com/insomnia-ubuntu/", ["default", "all"], {
        arch: dpkgArch,
        trusted: true,
      }],
    ],
    pins: [
      ["*", "o=Debian,n=buster", 1],
      ["*", "o=packagecloud.io/slacktechnologies/slack", 1],
      ["*", "l=insomnia-ubuntu", 1],
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
      "insomnia",
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
  dropbox: {
    links: [
      {
        dropbox: "ProgramData/DBeaver/General",
        darwin: "~/Library/DBeaverData/workspace6/General",
      },
    ],
  },
};

async function getDebianVersion() {
  try {
    const result = await cmd(["lsb_release", "-cs"], { stdout: "piped" });
    if (!result.success) return null;
    return await result.output();
  } catch (err) {
    return null;
  }
}

async function getDpkgArch() {
  try {
    const result = await cmd(["dpkg", "--print-architecture"], { stdout: "piped" });
    if (!result.success) return null;
    return await result.output();
  } catch (err) {
    return null;
  }
}

export default config;
