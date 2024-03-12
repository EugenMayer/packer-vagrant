DEFAULT_GOAL=all

# ################  debian
image_debian_vbox:
	cd ./debian && ./build_virtualbox.sh -var-file="debian12.pkrvars.hcl" debian.pkr.hcl

image_debian_big_vbox:
	cd ./debian && ./build_virtualbox.sh -var-file="debian12.pkrvars.hcl" -var "disk_size=20000" debian.pkr.hcl

image_debian11_vbox:
	cd ./debian && ./build_virtualbox.sh -var-file="debian11.pkrvars.hcl" debian.pkr.hcl

image_debian11_big_vbox:
	cd ./debian && ./build_virtualbox.sh -var-file="debian11.pkrvars.hcl" -var "disk_size=20000" debian.pkr.hcl

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
