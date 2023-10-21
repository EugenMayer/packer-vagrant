packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "~> 1"
    }
  }
}

variable "box_basename" {
  type    = string
  default = "debian-12.0"
}

variable "cpus" {
  type    = string
  default = "1"
}

variable "disk_size" {
  type    = string
  default = "10960"
}

variable "domain" {
  type    = string
  default = ""
}

variable "headless" {
  type    = string
  default = "false"
}

variable "http_proxy" {
  type    = string
  default = "${env("http_proxy")}"
}

variable "https_proxy" {
  type    = string
  default = "${env("https_proxy")}"
}

variable "iso_checksum" {
  type    = string
  default = "9da6ae5b63a72161d0fd4480d0f090b250c4f6bf421474e4776e82eea5cb3143bf8936bf43244e438e74d581797fe87c7193bbefff19414e33932fe787b1400f"
}

variable "iso_debian_version" {
  type    = string
  default = "12.1.0"
}

variable "memory" {
  type    = string
  default = "1024"
}

variable "name" {
  type    = string
  default = "debian-"
}

variable "no_proxy" {
  type    = string
  default = "${env("no_proxy")}"
}

variable "password" {
  type    = string
  default = "vagrant"
}

variable "preseed_qemu_path" {
  type    = string
  default = "debian12/preseed_qemu.cfg"
}

variable "preseed_virtualbox_path" {
  type    = string
  default = "debian12/preseed.cfg"
}

variable "ssh_port" {
  type    = string
  default = "22"
}

variable "template" {
  type    = string
  default = "debian-12.0-amd64"
}

variable "user" {
  type    = string
  default = "vagrant"
}

variable "version" {
  type    = string
  default = "TIMESTAMP"
}

locals {
  iso_template_url = "http://cdimage.debian.org/cdimage/archive/${var.iso_debian_version}/amd64/iso-cd/debian-${var.iso_debian_version}-amd64-netinst.iso"
}

source "qemu" "vm" {
  boot_command     = ["<esc><wait>", "install <wait>", " net.ifnames=1 <wait>", " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.preseed_qemu_path} <wait>", "debian-installer=en_US.UTF-8 <wait>", "auto <wait>", "locale=en_US.UTF-8 <wait>", "kbd-chooser/method=us <wait>", "keyboard-configuration/xkb-keymap=us <wait>", "netcfg/get_hostname={{ .Name }} <wait>", "netcfg/get_domain=${var.domain} <wait>", "fb=false <wait>", "debconf/frontend=noninteractive <wait>", "console-setup/ask_detect=false <wait>", "console-keymaps-at/keymap=us <wait>", "grub-installer/bootdev=/dev/sda <wait>", "user-setup/allow-password-weak=true ", "passwd/root-login=false ", "passwd/make-user=true ", "passwd/username=\"${var.user}\" ", "passwd/user-fullname=\"${var.user}\" ", "passwd/user-uid=\"1000\" ", "passwd/user-password=\"${var.password}\" passwd/user-password-again=\"${var.password}\" ", "partman-auto/disk=\"/dev/vda /dev/vdb\" ", "<enter><wait>"]
  boot_wait        = "10s"
  disk_interface   = "virtio"
  disk_size        = "${var.disk_size}"
  format           = "qcow2"
  headless         = "${var.headless}"
  http_directory   = "../resources/http"
  iso_checksum     = "${var.iso_checksum}"
  iso_url          = "${local.iso_template_url}"
  net_device       = "virtio-net"
  output_directory = "packer-${var.template}-qemu"
  qemuargs         = [["-drive", "file=system_disk_qemu.qcow2,if=virtio,index=0,format=qcow2,id=disk0"], ["-drive", "file=data_disk_qemu.qcow2,if=virtio,index=1,format=qcow2,id=disk1"]]
  shutdown_command = "echo 'vagrant' | sudo -S /sbin/shutdown -hP now"
  ssh_password     = "${var.password}"
  ssh_port         = "${var.ssh_port}"
  ssh_username     = "${var.user}"
  ssh_wait_timeout = "10000s"
  vm_name          = "${var.template}"
}

source "virtualbox-iso" "vm" {
  boot_command            = ["<esc><wait>", "install <wait>", " net.ifnames=1 <wait>", " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.preseed_virtualbox_path} <wait>", "debian-installer=en_US.UTF-8 <wait>", "auto <wait>", "locale=en_US.UTF-8 <wait>", "kbd-chooser/method=us <wait>", "keyboard-configuration/xkb-keymap=us <wait>", "netcfg/get_hostname={{ .Name }} <wait>", "netcfg/get_domain=${var.domain} <wait>", "fb=false<wait>", "debconf/frontend=noninteractive <wait>", "console-setup/ask_detect=false <wait>", "console-keymaps-at/keymap=us <wait>", "passwd/make-user=false", "passwd/root-login=true ", "passwd/root-password=\"${var.password}\" passwd/root-password-again=\"${var.password}\" ", "partman-auto/disk=\"/dev/sda /dev/sdb\" ", "<enter><wait>"]
  boot_wait               = "5s"
  cpus                    = "${var.cpus}"
  disk_size               = "${var.disk_size}"
  guest_additions_path    = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_os_type           = "Debian_64"
  hard_drive_interface    = "sata"
  headless                = "${var.headless}"
  http_directory          = "../resources/http"
  iso_checksum            = "${var.iso_checksum}"
  iso_url                 = "${local.iso_template_url}"
  memory                  = "${var.memory}"
  output_directory        = "packer-${var.template}-virtualbox"
  shutdown_command        = "/sbin/shutdown -hP now"
  ssh_password            = "${var.password}"
  ssh_port                = "${var.ssh_port}"
  ssh_pty                 = true
  ssh_read_write_timeout  = "20m"
  ssh_timeout             = "10000s"
  ssh_username            = "${var.user}"
  vboxmanage              = [["modifyvm", "{{ .Name }}", "--memory", "${var.memory}"], ["modifyvm", "{{ .Name }}", "--cpus", "${var.cpus}"], ["createhd", "disk", "--format", "VMDK", "--filename", "data_disk.vmdk", "--variant", "STREAM", "--size", "15000"], ["storageattach", "{{ .Name }}", "--storagectl", "SATA Controller", "--port", "1", "--type", "hdd", "--medium", "data_disk.vmdk"]]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "${var.template}"
  vrdp_port_max           = 5901
  vrdp_port_min           = 5901
}

build {
  sources = ["source.qemu.vm", "source.virtualbox-iso.vm"]

  provisioner "shell" {
    environment_vars = ["HOME_DIR=/home/vagrant", "http_proxy=${var.http_proxy}", "https_proxy=${var.https_proxy}", "no_proxy=${var.no_proxy}"]
    execute_command  = "echo 'vagrant' | {{ .Vars }} sudo -S -E sh -eux '{{ .Path }}'"
    scripts          = ["../resources/scripts/debian/networking.sh", "../resources/scripts/debian/vagrant.sh", "../resources/scripts/debian/cleanup.sh"]
  }

  post-processor "vagrant" {
    keep_input_artifact = true
    output              = "builds/${var.box_basename}.{{ .Provider }}.box"
  }
}
