#!/usr/bin/env bash

# Add sbin to PATH
export PATH=/usr/local/sbin:/usr/sbin:/sbin:~/.srk/src/bin:~/.local/bin:$PATH

function used-ports {
  sudo lsof -i -P -n | grep LISTEN
}

function sm {
  smerge -n .
}

function patch-vscodium-marketplace {
  productJson="/usr/share/codium/resources/app/product.json"
  cat "${productJson}" |
    jq '.extensionsGallery.serviceUrl = "https://marketplace.visualstudio.com/_apis/public/gallery"' |
    jq '.extensionsGallery.itemUrl = "https://marketplace.visualstudio.com/items"' |
    jq -M |
    sudo tee "${productJson}" >/dev/null
}

function upgrade-pipx { (
  pip3 install pipx
); }

function upgrade-telegram { (
  rm -rf ~/Software/Telegram
  mkdir -p ~/Software/Telegram
  cd ~/Software/Telegram || return
  wget -O telegram.tar.xz https://telegram.org/dl/desktop/linux
  tar -xf telegram.tar.xz
  mv Telegram t
  mv t/* .
  rmdir t
  rm telegram.tar.xz
  rm -f ~/bin/telegram
  ln -s "$(pwd)/Telegram" ~/bin/telegram
); }

function upgrade-docker-compose { (
  ~/.local/bin/pipx install docker-compose
); }

function upgrade-minecraft-launcher { (
  mkdir -p ~/Downloads/MinecraftLauncher
  cd ~/Downloads/MinecraftLauncher || return
  rm -f Minecraft.deb
  wget "https://launcher.mojang.com/download/Minecraft.deb"
  sudo apt install ./Minecraft.deb
); }

function upgrade-discord { (
  mkdir -p ~/Downloads/Discord
  cd ~/Downloads/Discord || return
  rm -f discord.deb
  wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
  sudo apt install ./discord.deb
); }

function upgrade-flipper { (
  mkdir -p ~/Software/Flipper
  cd ~/Software/Flipper || return
  rm -rf *
  curl -L --output __flipper.zip "https://www.facebook.com/fbflipper/public/linux"
  unzip __flipper.zip
  rm __flipper.zip
  ln -s "$(pwd)/flipper" ~/bin/flipper
); }

function upgrade-appium { (
  mkdir -p ~/Software/Appium
  cd ~/Software/Appium || return
  rm -rf *
  latest_version=$(curl --silent "https://api.github.com/repos/appium/appium-desktop/releases/latest" | jq -r ".name")
  printf "%s\n\n" "Downloading Appium ${latest_version}"
  wget "https://github.com/appium/appium-desktop/releases/download/v${latest_version}/Appium-Server-GUI-linux-${latest_version}.AppImage"
  chmod +x "Appium-Server-GUI-linux-${latest_version}.AppImage"
  ln -s "$(pwd)/Appium-Server-GUI-linux-${latest_version}.AppImage" ~/bin/appium
); }

function upgrade-binmerge { (
  rm -rf ~/Software/binmerge
  mkdir -p ~/Software/binmerge
  git clone "https://github.com/putnam/binmerge.git" ~/Software/binmerge
  cd ~/Software/binmerge || return
  git reset --hard "7218522aac721f6b0dcc2efc1b38f7d286979c7a"
  rm -rf ~/bin/binmerge
  ln -s "$(pwd)/binmerge" ~/bin/binmerge
); }

function upgrade-firefox { (
  rm -rf ~/Software/firefox
  mkdir -p ~/Software/firefox
  cd ~/Software/firefox || return
  curl -Lo firefox.tar.bz2 \
    "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US"
  tar -xvf firefox.tar.bz2
  sudo rm -rf /opt/firefox
  sudo mv ./firefox /opt/firefox
  sudo chown -R root:root /opt/firefox
  sudo rm -f /usr/local/bin/firefox
  sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox
  sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser /opt/firefox/firefox 200
  sudo update-alternatives --set x-www-browser /opt/firefox/firefox
  srk firefox configure
); }

function upgrade-yq { (
  rm -rf ~/Software/yq
  mkdir -p ~/Software/yq
  cd ~/Software/yq || return
  latest_version=$(curl --silent "https://api.github.com/repos/mikefarah/yq/releases/latest" | jq -r ".tag_name")
  printf "%s\n\n" "Downloading yq ${latest_version}"
  curl -Lo yq "https://github.com/mikefarah/yq/releases/download/${latest_version}/yq_linux_amd64"
  chmod +x yq
  rm -rf ~/bin/yq
  ln -s "$(pwd)/yq" ~/bin/yq
); }

function upgrade-htmlq { (
  rm -rf ~/Software/htmlq
  mkdir -p ~/Software/htmlq
  cd ~/Software/htmlq || return
  latest_version=$(curl --silent "https://api.github.com/repos/mgdm/htmlq/releases/latest" | jq -r ".tag_name")
  printf "%s\n\n" "Downloading htmlq ${latest_version}"
  curl -Lo htmlq.tar.gz "https://github.com/mgdm/htmlq/releases/download/${latest_version}/htmlq-x86_64-linux.tar.gz"
  tar -xzf htmlq.tar.gz
  rm -rf ~/bin/htmlq
  ln -s "$(pwd)/htmlq" ~/bin/htmlq
); }

function upgrade-fnmt-tools { (
  rm -rf ~/Software/fnmt
  mkdir -p ~/Software/fnmt
  cd ~/Software/fnmt || return

  configurador_download_url=$(curl -sL "https://www.sede.fnmt.gob.es/descargas/descarga-software/instalacion-software-generacion-de-claves" | htmlq --attribute href 'a[href*="amd64.deb"]')
  printf "%s\n%s\n\n" "Downloading Configurador:" "${configurador_download_url}"
  curl -Lo configurador.deb "${configurador_download_url}"
  printf "%s\n" ""

  autofirma_download_url=$(curl -sL "https://firmaelectronica.gob.es/Home/Descargas.html" | htmlq --attribute href 'a[href$="AutoFirma_Linux.zip"]')
  printf "%s\n%s\n\n" "Downloading AutoFirma:" "${autofirma_download_url}"
  curl -Lo autofirma.zip "${autofirma_download_url}"
  printf "%s\n" ""

  sudo apt install ./configurador.deb
  printf "%s\n" ""

  unzip autofirma.zip
  sudo apt install ./AutoFirma*.deb
); }

function upgrade-dnie-tools { (
  rm -rf ~/Software/dnie
  mkdir -p ~/Software/dnie
  cd ~/Software/dnie || return

  deb_download_url="https://www.dnielectronico.es$(curl -sL 'https://www.dnielectronico.es/portaldnie/PRF1_Cons02.action?pag=REF_1112' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:99.0) Gecko/20100101 Firefox/99.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-Fetch-Dest: document' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-Site: cross-site' -H 'Cache-Control: max-age=0' -H 'TE: trailers' | htmlq --attribute href 'a[href*="amd64.deb"]')"
  printf "%s\n%s\n\n" "Downloading libpkcs11-dnie:" "${deb_download_url}"
  curl -Lo libpkcs11_dnie.deb "${deb_download_url}"
  printf "%s\n" ""

  pdf_download_url="https://www.dnielectronico.es$(curl -sL 'https://www.dnielectronico.es/portaldnie/PRF1_Cons02.action?pag=REF_1111' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:99.0) Gecko/20100101 Firefox/99.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'Referer: https://www.dnielectronico.es/portaldnie/PRF1_Cons02.action?pag=REF_1110' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-Fetch-Dest: document' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-Site: same-origin' -H 'Sec-Fetch-User: ?1' -H 'TE: trailers' | htmlq --attribute href 'a[href*=".pdf"]' | tail -n1)"
  printf "%s\n%s\n\n" "Downloading PDF:" "${deb_download_url}"
  curl -Lo instructions.pdf "${pdf_download_url}"
  printf "%s\n" ""

  sudo apt install pcsc-tools
  sudo apt install ./libpkcs11_dnie.deb

  sudo rm /usr/local/share/ca-certificates/AC_RAIZ_DNIE_2.crt
  sudo cp /usr/share/libpkcs11-dnie/AC\ RAIZ\ DNIE\ 2.crt /usr/local/share/ca-certificates/AC_RAIZ_DNIE_2.crt
  sudo chmod 644 /usr/local/share/ca-certificates/AC_RAIZ_DNIE_2.crt

  sudo update-ca-certificates
); }

function upgrade { (
  sudo apt update
  sudo apt upgrade
  patch-vscodium-marketplace
  asdf update
  asdf plugin update --all
); }

function dmenu-flush { (
  rm ~/.cache/dmenu_run
); }

function backup-anbernic { (
  cd ~/Dropbox/Backup/Anbernic_Saves/ReGBA || return
  scp root@10.1.1.2:/media/data/local/home/.gpsp/* .
); }

function my-commits-here {
  smerge search 'author:"Carlos Fdez. Llamas <hello@sirikon.me>"' .
}

function to-clipboard {
  xclip -sel clip
}

function srk-launch-logs { (
  local program="${1}"
  sudo cat /var/log/syslog |
    grep "${program}@srk-launch"
); }
