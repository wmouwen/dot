# Arch Installation

## Create bare system

### Create bootable media

Download a bootable image from [archlinux.org](https://archlinux.org/download/). Burn it to some bootable media. Boot
the media on the target machine.

### Create logical partitions

Use fdisk to start partitioning the devices.

```shell
# List available devices
fdisk --list

# Start partitioning the device
fdisk /dev/nvme0n1
```

Optionally, create a new GPT partition table.

* 512MB partition at the start of the boot device for EFI (`/boot/efi`), partition type `EFI (1)`. This will be FAT32.
* 1GB partition behind it for `/boot`, type `Linux filesystem (20)` for an `ext4` type filesystem.
* Any other partitions. LUKS encrypted partitions should get the type `Linux LVM (30)`, non-encrypted basic `ext4`
  filesystems should get `Linux filesystem (20)`.

Exit fdisk. Format the non-lvm partitions if needed.

* For the EFI partition, this is `mkfs.fat -F 32 /dev/nvme0n1p1`.
* For non-encrypted ext4 partitions, this is `mkfs.ext4 /dev/nvme0n1p2`.
* LUKS encrypted partitions should not be formatted, yet.

### Create encrypted partitions

> __LVM Configuration__
>
> For those new to LVM, the basic building blocks of LVM are:
>
> __Physical volume (PV)__
> * Partition on hard disk (or even the disk itself or loopback file) on which you can have volume groups.
> * It has a special header and is divided into physical extents.
> * Think of physical volumes as big building blocks used to build your hard drive.
>
> __Volume group (VG)__
> * Group of physical volumes used as a storage volume (as one disk).
> * They contain logical volumes.
> * Think of volume groups as hard drives.
>
> __Logical volume (LV)__
> * A “virtual/logical partition” that resides in a volume group and is composed of physical extents.
> * Think of logical volumes as normal partitions.
>
> __Physical extent (PE)__
> * The smallest size in the physical volume that can be assigned to a logical volume (default 4MiB).
> * Think of physical extents as parts of disks that can be allocated to any partition.

Set up a logical encryption for one or more virtual LUKS partitions.

```shell
cryptsetup luksFormat --key-size 512 --hash sha512 /dev/nvme0n1p3
```

Once formatted, open the partition for further handling.

```shell
cryptsetup open --type luks /dev/nvme0n1p3 my_luks_volume
```

The opened luks volume is now available at `/dev/mapper/my_luks_volume`.

Create the "physical" volume in the now available device and create a volume group to go along with it.

```shell
pvcreate --dataalignment 1m /dev/mapper/my_luks_volume
vgcreate my_volume_group /dev/mapper/my_luks_volume
```

The created volume group is now available at `/dev/my_volume_group/`.

Create the logical volumes (partitions) within the volume group.

```shell
lvcreate my_volume_group --name my_root_partition --size 50GB
lvcreate my_volume_group --name my_homedir_partition --size 100%FREE
```

Partition the new volumes.

```shell
mkfs.ext4 /dev/my_volume_group/my_root_partition
mkfs.ext4 /dev/my_volume_group/my_homedir_partition
```

### Mount

Mount the partitions where Arch will go, except the EFI partition. Mounting points are created where necessary.

```shell
mount /dev/my_volume_group/my_root_partition /mnt

mkdir /mnt/home
mount /dev/my_volume_group/my_homedir_partition /mnt/home

mkdir /mnt/boot
mount /dev/nvme0n1p2 /mnt/boot
```

Create the `/etc` directory.

```shell
mkdir /mnt/etc
```

### Generate fstab

Without the EFI directory mounted, generate the fstab file.

```shell
genfstab -t UUID /mnt >> /mnt/etc/fstab
```

### Install the base system

```shell
pacstrap -i /mnt base linux linux-firmware
```

### Chroot into the new system

After this step everything will be done from within the chroot.

```shell
arch-chroot /mnt
```

## Install necessities

### Base packages

```shell
pacman --sync linux-headers base-devel lvm2 sudo netctl dhcpcd wpa_supplicant wireless-tools dialog
```

### Bootloader

Install GRUB2 with tools.

```shell
pacman -S grub efibootmgr dosfstools mtools os-prober
```

Edit the default GRUB settings to decrypt partitions.

```shell
# File:/etc/default/grub

GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 cryptodevice=/dev/nvme0n1p3:volumegroup:allow-discards quiet"
GRUB_ENABLE_CRYPTODISK=y
```

Mount the EFI partition.

```shell
mkdir /boot/EFI
mount /dev/nvme0n1p1 /boot/EFI
```

Install GRUB.

```shell
mkdir /boot/grub/locale
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
grub-mkconfig -o /boot/grub/grub.cfg
```

### Initial RAM disk image

The script `mkinitcpio` creates an initial RAM environment for linux to start off with. The scripts needs to be made
aware of LVM if an LVM partition was created.

Edit the `/etc/mkinitcpio.conf` file. Add the hooks `encrypt` and `lvm2`. They should be strictly before
the `filesystems` hook.

```shell
# File: /etc/mkinitcpio.conf

HOOKS=(base udev autodetect modconf block encrypt lvm2 filesystems keyboard fsck)
```

Afterwards run `mkinitcpio` to rebuild the initial RAM environment.

```shell
mkinitcpio --preset linux
```

### Set system hostname

The file `/etc/hostname` should contain a single line with the hostname.

```shell
# File: /etc/hostname

my_hostname
```

The file `/etc/hosts` should contain minimal entries for dns loopback.

```shell
# File: /etc/hosts

127.0.0.1  localhost
::1        localhost
127.0.1.1  my_hostname.localdomain my_hostname
```

### Set locale

Uncomment the desired locales in `/etc/locale.gen`

```shell
# File: /etc/locale.gen

en_US.UTF-8
```

Run locale-gen to install the locale correctly.

```shell
locale-gen
```

### Initial users

Change the password of the root user.

```shell
passwd root
```

Create a new user.

```shell
useradd --create-home --gid users --groups wheel my_username
passwd my_username
```

Allow the user to use its sudo rights. Using `visudo` uncomment the following line:

```shell
%wheel ALL=(ALL) ALL
```

## Bonus packages

```shell
pacman --sync nano vim
```
