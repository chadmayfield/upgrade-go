# upgrade-go

Upgrading [go](https://golang.org) in 40 lines of bash. [Blog post here](https://chadmayfield.com/2019/08/29/upgrading-go-in-40-lines-of-bash/).

### Requirements
* Linux system with [golang](https://golang.org/dl/) installed (usually to `/usr/local/go`)
* A user with `sudo` privileges
* Internet access
* [curl](https://curl.haxx.se)
* tar
* gzip

### Sample Output

```
chad@dev-vm:~$ ./upgrade_go_linux.sh
This will upgrade go... are you sure? (Y/N) y
Found: https://dl.google.com/go/go1.12.9.linux-amd64.tar.gz
Downloading now...
Downloaded 127961523 bytes in 4.606516s
Uncompressing: go1.12.9.linux-amd64.tar.gz
Updated to go version go1.12.9 linux/amd64!
```
