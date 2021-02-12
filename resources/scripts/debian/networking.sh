#!/bin/sh -eux

rm -rf /dev/.udev/ /var/lib/dhcp/*;

# Adding a 2 sec delay to the interface up, to make the dhclient happy
echo "pre-up sleep 2" >> /etc/network/interfaces
