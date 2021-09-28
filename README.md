Packer based templates to build boxes for vagrant

## Images

## Debian

Published under

- Bullseye: https://app.vagrantup.com/eugenmayer/boxes/debian11
- Buster: https://app.vagrantup.com/eugenmayer/boxes/debian10
- Stretch: https://app.vagrantup.com/eugenmayer/boxes/debian9

Aspects

- using 2 drives, one for the system, one for data ( check pre-seeds )
- extra volume for /var/log to ensure we cannot run full due to logs
- LVM with 2 vgs, one for each drive (system/data)

Usage as a platform would be

```yaml
platforms:
  - name: eugenmayer/debian10
    driver:
      box: eugenmayer/debian10
      box_version: '10.10.0'
  - name: eugenmayer/debian11
    driver:
      box: eugenmayer/debian11
      box_version: '10.11.0'
```

## Build yourself

for example

```bash
# debian 10
make image_debian_vbox
make image_debian_qemu

# debian 9
make image_debian9_vbox
make image_debian9_qemu
```

You can then start the box locally without uploading it

```
make run_locally
vagrant ssh
```
