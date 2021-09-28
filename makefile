DEFAULT_GOAL=all

# ################  debian
image_debian_vbox_headless:
	cd ./debian && ./build_virtualbox.sh -var "post_shutdown_delay=2m" -var 'headless=true' debian11.0.json

image_debian_vbox:
	# without headless, -var "post_shutdown_delay=2m"  is needed due to https://github.com/hashicorp/packer/issues/2401#issuecomment-287241531
	cd ./debian && ./build_virtualbox.sh -var "post_shutdown_delay=2m" debian11.0.json

image_debian_big_vbox:
	# without headless, -var "post_shutdown_delay=2m"  is needed due to https://github.com/hashicorp/packer/issues/2401#issuecomment-287241531
	cd ./debian && ./build_virtualbox.sh -var "post_shutdown_delay=2m" -var "disk_size=20000" -var "preseed_virtualbox_path=debian11/preseed-big.cfg" debian11.0.json

image_debian_qemu:
	cd ./debian && ./build_qemu.sh debian11.0json

image_debian10_big_vbox:
	# without headless, -var "post_shutdown_delay=2m"  is needed due to https://github.com/hashicorp/packer/issues/2401#issuecomment-287241531
	cd ./debian && ./build_virtualbox.sh -var "post_shutdown_delay=2m" -var "disk_size=20000" -var "preseed_virtualbox_path=debian10/preseed-big.cfg" debian10.0.json

image_debian10_vbox:
	cd ./debian && ./build_virtualbox.sh debian10.10.json

image_debian10_qemu:
	cd ./debian && ./build_qemu.sh debian10.10.json

image_debian: image_debian_vbox image_debian_qemu

clean:
	rm -fr debian/builds
	rm -fr debian/packer_cache
	rm -fr debian/packer-debian-*-amd64-virtualbox 
### test stuff

run_locally:
	vagrant box add --force --name eugenmayer/debian10test debian/builds/debian-10.8.virtualbox.box
	rm -f Vagrantfile
	vagrant init eugenmayer/debian10test
	vagrant destroy || true
	vagrant up

cleanup_run:
	 vagrant box remove eugenmayer/debian10test --box-version=0
	 vagrant destroy || true
	 rm -f Vagrantfile
