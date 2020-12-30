# Wi-Fi

Connect to a Wi-Fi network using the previously installed `netctl` and `wifi-menu`.

## Auto reconnect

After a connection has been made, you can configure the system to automatically reconnect on the next boot. Add a
priority to the profile configuration to enable the auto reconnect.

```shell
# File: /etc/netctl/wlo1-my-wifi-ap.conf

Priority=10
```

Enable the autoconnect service.

```shell
systemctl enable netctl-auto@wlo1.service
```
