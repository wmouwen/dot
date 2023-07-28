# AUR

To enable AUR support and download [Yay](https://github.com/Jguer/yay), download the latest version from the AUR
manually and install the package.

```shell
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## Colored Yay

Edit the file /etc/pacman.conf and uncomment the following line

```shell
# File: /etc/pacman.conf

Color
CheckSpace
VerbosePkgLists
ParallelDownloads = 5
```

## Mirror ranking

```shell
yay -S reflector
reflector --sort=score --country=NL,BE,LU,DE > /etc/pacman.d/mirrorlist
```
