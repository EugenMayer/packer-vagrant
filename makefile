DEFAULT_GOAL=all

# ################  debian
image_debian_vbox:
	cd ./debian && ./build_virtualbox.sh

image_debian_qemu:
	cd ./debian && ./build_qemu.sh

image_debian: image_debian_vbox image_debian_qemu

clean:
	rm -fr debian/builds
	rm -fr debian/packer_cache
	rm -fr debian/packer-debian-*-amd64-virtualbox 
