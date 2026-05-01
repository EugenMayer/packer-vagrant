DEFAULT_GOAL=all

# ################  debian
image_debian_vbox:
	cd ./debian && ./build_virtualbox.sh -var-file="debian13.pkrvars.hcl" -var "root_disk_size=5000" -var "data_disk_size=5000" debian.pkr.hcl

image_debian_big_vbox:
	cd ./debian && ./build_virtualbox.sh -var-file="debian13.pkrvars.hcl" -var box_basename="debian13big" -var "root_disk_size=10000" -var "data_disk_size=35000" debian.pkr.hcl

image_debian12_vbox:
	cd ./debian && ./build_virtualbox.sh -var-file="debian12.pkrvars.hcl" -var "root_disk_size=5000" -var "data_disk_size=5000" debian.pkr.hcl

image_debian12_big_vbox:
	cd ./debian && ./build_virtualbox.sh -var-file="debian12.pkrvars.hcl" -var "droot_isk_size=10000" -var "data_disk_size=35000"debian.pkr.hcl

clean:
	rm -fr debian/builds
	rm -fr debian/packer_cache
	rm -fr debian/packer-debian-*-amd64-virtualbox 
### test stuff

run_locally:
	vagrant box add --force --architecture=amd64 kontextwork/debian13test debian/builds/debian-13.virtualbox.box
	rm -f Vagrantfile
	vagrant init kontextwork/debian13test
	vagrant destroy || true
	vagrant up

cleanup_run:
	 vagrant box remove kontextwork/debian13test --box-version=0
	 vagrant destroy || true
	 rm -f Vagrantfile
