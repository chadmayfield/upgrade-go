#!/bin/bash

# update_go.sh - update installation of go on linux

# author  : Chad Mayfield (chad@chd.my)
# license : gplv3

#### EXAMPLE OUTPUT ####
# chad@dev-vm:~$ ./update_go.sh
# This will upgrade go... are you sure? (Y/N) y
# Found URL https://dl.google.com/go/go1.14.linux-amd64.tar.gz
# Downloading now...
# Downloaded 123550266 bytes in 5.057913s
# Uncompressing go1.14.linux-amd64.tar.gz
# Updated to go version go1.14 linux/amd64!
########################

fail() {
    echo "$@"; exit 1;
}

override="$1"

command -v curl >/dev/null 2>&1 || \
    { echo >&2 "ERROR: curl is required, but it's not installed!"; exit 1; }

#read -t 10 -p "This will upgrade go... are you sure? (Y/N) " answer -n 1 -r 
read -t 10 -p "This will upgrade go... are you sure? (Y/N) " answer
echo " "

url="$(curl -s https://golang.org/VERSION?m=text)"
#url="$(curl -s https://golang.org/dl/ | grep 'downloadBox.*linux' | grep -Po '(?<=href=")[^"]*(?=")')"

check_version() {
    current_ver="$(/usr/local/go/bin/go version | awk '{print $3}')"
    
    if [ $current_ver == "$url" ]; then
        if ! [[ $override =~ "force" ]]; then
            fail "$current_ver is already installed!"
        fi
    fi
}

get_arch() {
    ARCH="$(uname -m)"

    if [[ $ARCH =~ x86_64 ]]; then
        ARCH="amd64" 
    elif [[ $ARCH =~ 386|686 ]]; then
        ARCH="386"
    elif [[ $ARCH =~ armv(6|7)l ]]; then
        ARCH="armv6l"
    elif [[ $ARCH =~ armv8 ]]; then
        ARCH="arm64"
    else
        fail "Unknown architecture: ${ARCH}!"
    fi
}

download() {
    if [ -d "${gpath}/go" ]; then
        if [ -n "${url+x}" ]; then
            printf "\nFound URL %s\nDownloading now...\n" "$url"
            curl -nsS "$url" -O -w "Downloaded %{size_download} bytes in %{time_total}s\n" || fail "Download failed!"
        else
            fail "URL not found!"
        fi
    else
        fail "Go is not installed at ${gpath}/go"
    fi

}

install() {
        printf "Uncompressing %s\n" "${url##*/}"
        sudo rm -rf "$gpath/go"
        sudo tar xzf "${url##*/}" -C "$gpath" || fail "Failed to uncompress ${url##*/}!"

        printf "Updated to %s!\n" "$($gpath/go/bin/go version)"
        rm -f "${url##*/}"
}

check_version

case $answer in
    [yY]* )
        if [[ $OSTYPE =~ "linux" ]]; then
            get_arch
            gpath="/usr/local/"
            url="https://dl.google.com/go/${url}.linux-${ARCH}.tar.gz"

            download
            install
        elif [[ $OSTYPE =~ "darwin" ]]; then
            get_arch
            gpath="/usr/local/"
            url="https://dl.google.com/go/${url}.darwin-${ARCH}.tar.gz"

            download
            install

            echo "Coming soon!"
        else
            fail "This must be run on a MacOS (darwin) or Linux system!"
        fi
        ;;

    [nN]* )
        fail "Exiting"
        ;;
    
     * )
        fail "ERROR: Unknown answer, $answer. Please answer Y or N."
        ;;
esac

#EOF