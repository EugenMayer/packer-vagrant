#!/bin/sh -eux

ln -s /dev/null /etc/udev/rules.d/70-persistent-net.rules;
rm -f /lib/udev/rules.d/75-persistent-net-generator.rules;
rm -rf /dev/.udev/ /var/lib/dhcp/*;

# Adding a 2 sec delay to the interface up, to make the dhclient happy
echo "pre-up sleep 2" >> /etc/network/interfaces

# ensure we remove the predictied networ settings and also ensure eth0 is configured using DHCP
sed -i 's/GRUB_CMDLINE_LINUX="\(.*\)"/GRUB_CMDLINE_LINUX="\1 net.ifnames=0"/' /etc/default/grub;
echo 'auto eth0' > /etc/network/interfaces.d/eth0.cfg;
echo 'iface eth0 inet dhcp' >> /etc/network/interfaces.d/eth0.cfg;
update-grub
update-initramfs -u

# we are not using /etc/network/interfaces.d/eth0.cfg by intention
# -> we need to override interfaces anyway due to the old defintion of the installer
# but also, still there are some service not supporting interfaces.d like proxmox

cat >/etc/network/interfaces <<EOL
source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug eth0
iface eth0 inet dhcp
EOL