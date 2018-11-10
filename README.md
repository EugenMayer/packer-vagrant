Packer based templates to build boxes for vagrant

Images
----

## Debian

Published under https://app.vagrantup.com/eugenmayer/boxes/debian9

 - using 2 drives, one for the system, one for data ( showing of in preseed )
 - extra volume for /var/log to ensure we cannot run full due to logs
 - LVM with 2 vgs, one for each drive (system/data)
 

Usage as a platform would be

```yaml
platforms:
  - name: eugenmayer/debian9
    driver:
      box: eugenmayer/debian9
      box_version: "9.5"
```


Build
-----

for example

```bash
make debian_vbox
make debian_qemu
```
