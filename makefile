DEFAULT_GOAL=all

# ################  debian
image_debian_vbox_headless:
	cd ./debian && ./build_virtualbox.sh -var "post_shutdown_delay=2m" -var 'headless=true' debian10.1.json

image_debian_vbox:
	# without headless, -var "post_shutdown_delay=2m"  is needed due to https://github.com/hashicorp/packer/issues/2401#issuecomment-287241531
	cd ./debian && ./build_virtualbox.sh -var "post_shutdown_delay=2m" debian10.1.json

image_debian_qemu:
	cd ./debian && ./build_qemu.sh debian10.1json

image_debian9_vbox:
    # yet we are building debian 9.3 due to rancher bugs with > 9.3
	cd ./debian && ./build_virtualbox.sh debian9.3.json

image_debian9_qemu:
	cd ./debian && ./build_qemu.sh debian9.3json

image_debian: image_debian_vbox image_debian_qemu

clean:
	rm -fr debian/builds
	rm -fr debian/packer_cache
	rm -fr debian/packer-debian-*-amd64-virtualbox 
### test stuff

run_locally:
	vagrant box add --force --name eugenmayer/debian9test debian/builds/debian-9.3.virtualbox.box
	rm -f Vagrantfile
	vagrant init eugenmayer/debian9test
	vagrant destroy || true
	vagrant up

cleanup_run:
	 vagrant box remove eugenmayer/debian9test --box-version=0
	 vagrant destroy || true
	 rm -f Vagrantfile