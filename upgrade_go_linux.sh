#!/bin/bash

# upgrade_go_linux.sh - update installation of go on linux

# author  : Chad Mayfield (chad@chd.my)
# license : gplv3

fail() {
    echo "ERROR:" "$@"; exit 1;
}

if [[ $OSTYPE =~ "linux" ]]; then

    command -v curl >/dev/null 2>&1 || \
        { echo >&2 "ERROR: curl is required, but it's not installed!"; exit 1; }

    read -t 10 -p "This will upgrade go... are you sure? (Y/N) " -n 1 -r

    gpath="/usr/local/"
    url="$(curl -s https://golang.org/dl/ | grep 'downloadBox.*linux' | grep -Po '(?<=href=")[^"]*(?=")')"

    if [ -d "${gpath}/go" ]; then
        if [ -n "${url+x}" ]; then
            printf "\nFound: %s\nDownloading now...\n" "$url"
            curl -nsS "$url" -O -w "Downloaded %{size_download} bytes in %{time_total}s\n" || fail "Download failed!"

            printf "Uncompressing: %s\n" "${url##*/}"
            sudo rm -rf "$gpath/go" || fail "Unable to remove prior install!"
            sudo tar xzf "${url##*/}" -C "$gpath" || fail "Failed to uncompress ${url##*/}!"

            printf "Updated to %s!\n" "$($gpath/go/bin/go version)" || fail "Uh-oh, go version failed! Is $GOPATH set?"
            rm -f "${url##*/}"
        else
            fail "URL not found!"
        fi
    else
        fail "Go is not installed at ${gpath}/go"
    fi
else
    fail "This must be run on a Linux system!"
fi