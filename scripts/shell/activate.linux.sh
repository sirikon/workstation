#!/usr/bin/env bash

export SRK_ROOT="$(realpath "$(dirname "${BASH_SOURCE[0]}")/../..")"
source "$SRK_ROOT/scripts/utils/utils.sh"

if [ -z "${SRK_ACTIVATED}" ]; then
    export SRK_ACTIVATED="true"
    export SRK_ORIGINAL_PATH="$PATH"
    log "Starting SSH Agent"
    eval "$(DISPLAY=:0 ssh-agent)"
fi

export POETRY_KEYRING_ENABLED="false"
export PATH="/usr/local/sbin:/usr/sbin:/sbin:$SRK_ROOT/scripts/bin:$SRK_ROOT/scripts/bin/linux:$HOME/bin:$SRK_ORIGINAL_PATH"
source "$SRK_ROOT/scripts/shell/activate.sh"

function sm {
    smerge -n .
}

function used-ports {
    sudo lsof -i -P -n | grep LISTEN
}

function my-commits-here {
    smerge search 'author:"Carlos Fdez. Llamas <hello@sirikon.me>"' .
}

function upgrade { (
    sudo apt-get update
    sudo apt-get upgrade
); }

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

# function dmenu-flush { (
#     rm ~/.cache/dmenu_run
# ); }

# function backup-anbernic { (
#     cd ~/Dropbox/Backup/Anbernic_Saves/ReGBA || return
#     scp root@10.1.1.2:/media/data/local/home/.gpsp/* .
# ); }
