# Time settings

```shell
# Sync with the internet
timedatectl set-ntp true

# Set hardware clock to local time. 1 if dualboot with windows, 0 otherwise.
timedatectl set-local-rtc 1

# Set timezone
timedatectl set-timezone Europe/Amsterdam

# Sync system and hardware clock
hwclock --adjust
hwclock --systohc
```
