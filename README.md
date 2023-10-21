Packer based templates to build boxes for vagrant

## Images

## Debian

Published under

- Bookworm: https://app.vagrantup.com/eugenmayer/boxes/debian12
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
      box_version: '11.0.0'
  - name: eugenmayer/debian12
    driver:
      box: eugenmayer/debian12
      box_version: '12.1.0'
```

## Build yourself

for example

```bash
# debian stable
make image_debian_vbox
make image_debian_qemu

# debian 11
make image_debian11_vbox
make image_debian11_qemu

# debian 10
make image_debian10_vbox
make image_debian10_qemu
```

You can then start the box locally without uploading it

```
make run_locally
vagrant ssh
```
