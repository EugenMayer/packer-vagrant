DEFAULT_GOAL=all

# ################  debian
image_debian_vbox:
    # yet we are building debian 9.3 due to rancher bugs with > 9.3
	cd ./debian && ./build_virtualbox.sh debian9.3json

image_debian_qemu:
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