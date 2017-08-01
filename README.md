Packer based templates to build boxes for vagrant

Images
----

## Debian

Published under https://app.vagrantup.com/eugenmayer/boxes/debian9

Usage as a platform would be

```yaml
platforms:
  - name: eugenmayer/debian9
    driver:
      box: eugenmayer/debian9
      box_version: "9.1"
```


Build
-----

for example

```bash
cd debian
packer build debian9.json
```
