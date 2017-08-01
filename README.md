Packer based templates to build boxes for vagrant

Debian9
----

Published under https://app.vagrantup.com/eugenmayer/boxes/debian9

Usage as a platform would be

```yaml
platforms:
  - name: eugenmayer/debian9
    driver:
      box: eugenmayer/debian9
      box_version: "9.1"
```
