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
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

variable "box_basename" {
  type    = string
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
  #default = "11d733d626d1c7d3b20cfcccc516caff2cbc57c81769d56434aab958d4d9b3af59106bc0796252aeefede8353e2582378e08c65e35a36769d5cf673c5444f80e"
}

variable "iso_debian_version" {
  type    = string
  #default = "12.4.0"
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

variable "user" {
  type    = string
  default = "root"
}

variable "password" {
  type    = string
  default = "vagrant"
}

variable "preseed_virtualbox_path" {
  type    = string
}

variable "ssh_port" {
  type    = string
  default = "22"
}

variable "version" {
  type    = string
  default = "TIMESTAMP"
}

locals {
  iso_template_url = "http://cdimage.debian.org/cdimage/archive/${var.iso_debian_version}/amd64/iso-cd/debian-${var.iso_debian_version}-amd64-netinst.iso"
}

source "virtualbox-iso" "vm" {
  boot_command            =  [
    "<esc><wait>",
    "/install.amd/vmlinuz initrd=/install.amd/initrd.gz \"net.ifnames=0 biosdevname=0 ip=dhcp ipv6.disable=1\" preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.preseed_virtualbox_path} <wait>",
    "fb=false <wait>",
    "auto-install/enable=true <wait>",
    "auto=true <wait>",

    "console-setup/ask_detect=false <wait>",
    "debconf/frontend=noninteractive <wait>",

    "debian-installer=en_US.UTF-8 <wait>",
    "locale=en_US.UTF-8 <wait>",
    "kbd-chooser/method=us <wait>",
    "keyboard-configuration/xkb-keymap=us <wait>",
    "netcfg/get_hostname={{ .Name }} <wait>",
    "netcfg/get_domain=${var.domain} <wait>",
    "console-keymaps-at/keymap=us <wait>",

    # root password is to be expected to align with the vagrant password
    "passwd/root-password=${var.password} <wait>",
    "passwd/root-password-again=${var.password} <wait>",
    # sda since we use virtualbox, vda for qemu
    "partman-auto/disk=\"/dev/sda /dev/sdb\" <wait>",
    "--- <enter><wait>"
  ]
  boot_wait               = "10s"
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
  output_directory        = "packer-${var.box_basename}-amd-virtualbox"
  shutdown_command        = "/sbin/shutdown -hP now"
  gfx_controller          = "vmsvga"
  gfx_vram_size           = "64"
  ssh_password            = "${var.password}"
  ssh_port                = "${var.ssh_port}"
  #ssh_pty                 = true
  ssh_read_write_timeout  = "20m"
  ssh_timeout             = "10m"
  ssh_username            = "${var.user}"
  vboxmanage              = [
    ["modifyvm", "{{ .Name }}", "--memory", "${var.memory}"],
    ["modifyvm", "{{ .Name }}", "--cpus", "${var.cpus}"],
    ["createhd", "disk", "--format", "VMDK", "--filename", "data_disk.vmdk", "--variant", "STREAM", "--size", "15000"],
    ["storageattach", "{{ .Name }}", "--storagectl", "SATA Controller", "--port", "1", "--type", "hdd", "--medium", "data_disk.vmdk"],
    ["modifyvm", "{{.Name}}", "--vrde", "on"],
    # Needed to fix VirtualBox7 http server access, seehttps://github.com/hashicorp/packer/issues/12118
    ["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"],
  ]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "${var.box_basename}"
  # see https://developer.hashicorp.com/packer/integrations/hashicorp/virtualbox/latest/components/builder/iso#run-configuration
  vrdp_port_max           = 5901
  vrdp_port_min           = 5901
  vrdp_bind_address       = "0.0.0.0"
}

build {
  sources = ["source.virtualbox-iso.vm"]
  provisioner "shell" {
    environment_vars = ["HOME_DIR=/home/vagrant", "http_proxy=${var.http_proxy}", "https_proxy=${var.https_proxy}", "no_proxy=${var.no_proxy}"]
    scripts          = [
      # provision vagrant user and ssh
      "../resources/scripts/debian/vagrant.sh",
      "../resources/scripts/debian/networking.sh",
      "../resources/scripts/debian/cleanup.sh"]
  }

  post-processor "vagrant" {
    keep_input_artifact = true
    output              = "builds/${var.box_basename}.{{ .Provider }}.box"
  }
}
