#!/bin/sh -eux

####################################### If needed enables old style network names ethX instead of new predictable ones ############################################

ln -s /dev/null /etc/udev/rules.d/70-persistent-net.rules
rm -f /lib/udev/rules.d/75-persistent-net-generator.rules
rm -rf /dev/.udev/ /var/lib/dhcp/*

# ensure we remove the predictied networ settings and also ensure eth0 is configured using DHCP
# sed -i 's/GRUB_CMDLINE_LINUX="\(.*\)"/GRUB_CMDLINE_LINUX="\1 net.ifnames=0"/' /etc/default/grub
#update-grub
#update-initramfs -u
#echo 'auto eth0' > /etc/network/interfaces.d/eth0.cfg
#echo 'allow-hotplug eth0' >> /etc/network/interfaces.d/eth0.cfg
#echo 'iface eth0 inet dhcp' >> /etc/network/interfaces.d/eth0.cfg


# we are not using /etc/network/interfaces.d/eth0.cfg by intention
# -> we need to override interfaces anyway due to the old definition of the installer
# but also, still there are some service not supporting interfaces.d like proxmox

cat >/etc/network/interfaces <<EOL
source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback
# The primary network interface
EOL
