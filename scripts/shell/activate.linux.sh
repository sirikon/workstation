#!/usr/bin/env bash

export SRK_ROOT="$(realpath "$(dirname "${BASH_SOURCE[0]}")/../..")"
if [ -z "${SRK_ORIGINAL_PATH}" ]; then
    export SRK_ORIGINAL_PATH="$PATH"
fi
export PATH="/usr/local/sbin:/usr/sbin:/sbin:$SRK_ROOT/scripts/bin:$HOME/bin:$SRK_ORIGINAL_PATH"
source "$(dirname "${BASH_SOURCE[0]}")/activate.sh"

if [ -z "${SSH_AGENT_PID}" ]; then
    eval "$(DISPLAY="${DISPLAY:-':0'}" ssh-agent)"
fi

function upgrade-keepassxc {
    latest_tag=$(curl --silent "https://api.github.com/repos/keepassxreboot/keepassxc/releases/latest" | jq -r ".tag_name")
    echo "Installing KeepassXC $latest_tag"
    mkdir -p "$HOME/bin"
    wget -O "$HOME/bin/keepassxc" "https://github.com/keepassxreboot/keepassxc/releases/download/${latest_tag}/KeePassXC-${latest_tag}-x86_64.AppImage"
    chmod +x "$HOME/bin/keepassxc"
}

# function used-ports {
#     sudo lsof -i -P -n | grep LISTEN
# }

# function sm {
#     smerge -n .
# }

# function patch-vscodium-marketplace {
#     productJson="/usr/share/codium/resources/app/product.json"
#     cat "${productJson}" |
#         jq '.extensionsGallery.serviceUrl = "https://marketplace.visualstudio.com/_apis/public/gallery"' |
#         jq '.extensionsGallery.itemUrl = "https://marketplace.visualstudio.com/items"' |
#         jq -M |
#         sudo tee "${productJson}" >/dev/null
# }

# function upgrade-pipx { (
#     pip3 install pipx
# ); }

# function upgrade-telegram { (
#     rm -rf ~/Software/Telegram
#     mkdir -p ~/Software/Telegram
#     cd ~/Software/Telegram || return
#     wget -O telegram.tar.xz https://telegram.org/dl/desktop/linux
#     tar -xf telegram.tar.xz
#     mv Telegram t
#     mv t/* .
#     rmdir t
#     rm telegram.tar.xz
#     rm -f ~/bin/telegram
#     ln -s "$(pwd)/Telegram" ~/bin/telegram
# ); }

# function upgrade-minecraft-launcher { (
#     mkdir -p ~/Downloads/MinecraftLauncher
#     cd ~/Downloads/MinecraftLauncher || return
#     rm -f Minecraft.deb
#     wget "https://launcher.mojang.com/download/Minecraft.deb"
#     sudo apt install ./Minecraft.deb
# ); }

# function upgrade-discord { (
#     mkdir -p ~/Downloads/Discord
#     cd ~/Downloads/Discord || return
#     rm -f discord.deb
#     wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
#     sudo apt install ./discord.deb
# ); }

# function upgrade-flipper { (
#     mkdir -p ~/Software/Flipper
#     cd ~/Software/Flipper || return
#     rm -rf *
#     curl -L --output __flipper.zip "https://www.facebook.com/fbflipper/public/linux"
#     unzip __flipper.zip
#     rm __flipper.zip
#     ln -s "$(pwd)/flipper" ~/bin/flipper
# ); }

# function upgrade-appium { (
#     mkdir -p ~/Software/Appium
#     cd ~/Software/Appium || return
#     rm -rf *
#     latest_version=$(curl --silent "https://api.github.com/repos/appium/appium-desktop/releases/latest" | jq -r ".name")
#     printf "%s\n\n" "Downloading Appium ${latest_version}"
#     wget "https://github.com/appium/appium-desktop/releases/download/v${latest_version}/Appium-Server-GUI-linux-${latest_version}.AppImage"
#     chmod +x "Appium-Server-GUI-linux-${latest_version}.AppImage"
#     ln -s "$(pwd)/Appium-Server-GUI-linux-${latest_version}.AppImage" ~/bin/appium
# ); }

# function upgrade-binmerge { (
#     rm -rf ~/Software/binmerge
#     mkdir -p ~/Software/binmerge
#     git clone "https://github.com/putnam/binmerge.git" ~/Software/binmerge
#     cd ~/Software/binmerge || return
#     git reset --hard "7218522aac721f6b0dcc2efc1b38f7d286979c7a"
#     rm -rf ~/bin/binmerge
#     ln -s "$(pwd)/binmerge" ~/bin/binmerge
# ); }

# # https://ftp.mozilla.org/pub/firefox/releases/
# function upgrade-firefox { (
#     target_version="${1:-""}"
#     url="https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US"
#     if [ "${target_version}" != "" ]; then
#         url="https://ftp.mozilla.org/pub/firefox/releases/${target_version}/linux-x86_64/en-US/firefox-${target_version}.tar.bz2"
#     fi
#     rm -rf ~/Software/firefox
#     mkdir -p ~/Software/firefox
#     cd ~/Software/firefox || return
#     curl -Lo firefox.tar.bz2 "${url}"
#     tar -xvf firefox.tar.bz2
#     sudo rm -rf /opt/firefox
#     sudo mv ./firefox /opt/firefox
#     sudo chown -R root:root /opt/firefox
#     sudo rm -f /usr/local/bin/firefox
#     sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox
#     sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser /opt/firefox/firefox 200
#     sudo update-alternatives --set x-www-browser /opt/firefox/firefox
# ); }

# function upgrade-yq { (
#     rm -rf ~/Software/yq
#     mkdir -p ~/Software/yq
#     cd ~/Software/yq || return
#     latest_version=$(curl --silent "https://api.github.com/repos/mikefarah/yq/releases/latest" | jq -r ".tag_name")
#     printf "%s\n\n" "Downloading yq ${latest_version}"
#     curl -Lo yq "https://github.com/mikefarah/yq/releases/download/${latest_version}/yq_linux_amd64"
#     chmod +x yq
#     rm -rf ~/bin/yq
#     ln -s "$(pwd)/yq" ~/bin/yq
# ); }

# function upgrade-htmlq { (
#     rm -rf ~/Software/htmlq
#     mkdir -p ~/Software/htmlq
#     cd ~/Software/htmlq || return
#     latest_version=$(curl --silent "https://api.github.com/repos/mgdm/htmlq/releases/latest" | jq -r ".tag_name")
#     printf "%s\n\n" "Downloading htmlq ${latest_version}"
#     curl -Lo htmlq.tar.gz "https://github.com/mgdm/htmlq/releases/download/${latest_version}/htmlq-x86_64-linux.tar.gz"
#     tar -xzf htmlq.tar.gz
#     rm -rf ~/bin/htmlq
#     ln -s "$(pwd)/htmlq" ~/bin/htmlq
# ); }

# function upgrade-fnmt-tools { (
#     rm -rf ~/Software/fnmt
#     mkdir -p ~/Software/fnmt
#     cd ~/Software/fnmt || return

#     configurador_download_url=$(curl -sL "https://www.sede.fnmt.gob.es/descargas/descarga-software/instalacion-software-generacion-de-claves" | htmlq --attribute href 'a[href*="amd64.deb"]')
#     printf "%s\n%s\n\n" "Downloading Configurador:" "${configurador_download_url}"
#     curl -Lo configurador.deb "${configurador_download_url}"
#     printf "%s\n" ""

#     autofirma_download_url=$(curl -sL "https://firmaelectronica.gob.es/Home/Descargas.html" | htmlq --attribute href 'a[href$="AutoFirma_Linux.zip"]')
#     printf "%s\n%s\n\n" "Downloading AutoFirma:" "${autofirma_download_url}"
#     curl -Lo autofirma.zip "${autofirma_download_url}"
#     printf "%s\n" ""

#     sudo apt install ./configurador.deb
#     printf "%s\n" ""

#     unzip autofirma.zip
#     sudo apt install ./AutoFirma*.deb
# ); }

# function upgrade-dnie-tools { (
#     rm -rf ~/Software/dnie
#     mkdir -p ~/Software/dnie
#     cd ~/Software/dnie || return

#     deb_download_url="https://www.dnielectronico.es$(curl -sL 'https://www.dnielectronico.es/portaldnie/PRF1_Cons02.action?pag=REF_1112' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:99.0) Gecko/20100101 Firefox/99.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-Fetch-Dest: document' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-Site: cross-site' -H 'Cache-Control: max-age=0' -H 'TE: trailers' | htmlq --attribute href 'a[href*="amd64.deb"]')"
#     printf "%s\n%s\n\n" "Downloading libpkcs11-dnie:" "${deb_download_url}"
#     curl -Lo libpkcs11_dnie.deb "${deb_download_url}"
#     printf "%s\n" ""

#     pdf_download_url="https://www.dnielectronico.es$(curl -sL 'https://www.dnielectronico.es/portaldnie/PRF1_Cons02.action?pag=REF_1111' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:99.0) Gecko/20100101 Firefox/99.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'Referer: https://www.dnielectronico.es/portaldnie/PRF1_Cons02.action?pag=REF_1110' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-Fetch-Dest: document' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-Site: same-origin' -H 'Sec-Fetch-User: ?1' -H 'TE: trailers' | htmlq --attribute href 'a[href*=".pdf"]' | tail -n1)"
#     printf "%s\n%s\n\n" "Downloading PDF:" "${pdf_download_url}"
#     curl -Lo instructions.pdf "${pdf_download_url}"
#     printf "%s\n" ""

#     sudo apt install pcsc-tools
#     sudo apt install ./libpkcs11_dnie.deb

#     sudo rm /usr/local/share/ca-certificates/AC_RAIZ_DNIE_2.crt
#     sudo cp /usr/share/libpkcs11-dnie/AC\ RAIZ\ DNIE\ 2.crt /usr/local/share/ca-certificates/AC_RAIZ_DNIE_2.crt
#     sudo chmod 644 /usr/local/share/ca-certificates/AC_RAIZ_DNIE_2.crt

#     sudo update-ca-certificates
# ); }

# function upgrade-aws-cli { (
#     rm -rf ~/Software/aws-cli
#     mkdir -p ~/Software/aws-cli
#     cd ~/Software/aws-cli || return

#     curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
#     unzip "awscliv2.zip"
#     sudo ./aws/install --update
# ); }

# function upgrade-yt-dlp { (
#     rm -rf ~/Software/yt-dlp
#     mkdir -p ~/Software/yt-dlp
#     cd ~/Software/yt-dlp || return

#     curl -L "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp" -o "yt-dlp"
#     chmod +x "yt-dlp"
#     rm -rf /usr/local/bin/yt-dlp
#     sudo ln -s "$(pwd)/yt-dlp" /usr/local/bin/yt-dlp
# ); }

# function upgrade { (
#     sudo apt update
#     sudo apt upgrade
#     patch-vscodium-marketplace
#     # asdf update
#     # asdf plugin update --all
#     flatpak update --assumeyes
# ); }

# function dmenu-flush { (
#     rm ~/.cache/dmenu_run
# ); }

# function backup-anbernic { (
#     cd ~/Dropbox/Backup/Anbernic_Saves/ReGBA || return
#     scp root@10.1.1.2:/media/data/local/home/.gpsp/* .
# ); }

# function my-commits-here {
#     smerge search 'author:"Carlos Fdez. Llamas <hello@sirikon.me>"' .
# }

# function to-clipboard {
#     xclip -sel clip
# }

# function srk-launch-logs { (
#     local program="${1}"
#     sudo cat /var/log/syslog |
#         grep "${program}@srk-launch"
# ); }
