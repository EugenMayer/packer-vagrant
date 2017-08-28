DEFAULT_GOAL=all

# ################  debian
image_debian_vbox:
	cd ./drupalwiki-host && ./build_virtualbox.sh

image_debian_qemu:
	cd ./drupalwiki-host && ./build_qemu.sh

image_debian: image_debian_vbox image_debian_qemu