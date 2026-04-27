Packer based templates to build boxes for vagrant

## Images

## Debian

Published under
- Trixie: https://portal.cloud.hashicorp.com/vagrant/discover/kontextwork/debian13
- Bookworm: https://portal.cloud.hashicorp.com/vagrant/discover/eugnemayer/debian12
- Bullseye: https://portal.cloud.hashicorp.com/vagrant/discover/eugenmayer/debian11
- Buster: https://portal.cloud.hashicorp.com/vagrant/discover/eugenmayer/debian10
- Stretch: https://portal.cloud.hashicorp.com/vagrant/discover/eugenmayer/debian9

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
      box_version: '11.9.0'
  - name: eugenmayer/debian12
    driver:
      box: eugenmayer/debian12
      box_version: '12.4.0'
  - name: kontextwork/debian13
    driver:
      box: kontextwork/debian13
      box_version: '13.3.0'
```

or 

```bash
vagrant init kontextwork/debian13
vagrant init eugenmayer/debian12

```

## Build yourself

for example

```bash
# debian stable
make image_debian_vbox

# debian 11
make image_debian12_vbox
```

You can then start the box locally without uploading it

```
make run_locally
vagrant ssh
```
