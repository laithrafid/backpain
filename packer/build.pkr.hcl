packer {
  required_plugins {
    googlecompute = {
      version = "1.0.0" 
      source  = "github.com/hashicorp/googlecompute"
    }
    virtualbox-iso = {
      version = "1.0.2"
      source  = "github.com/hashicorp/virtualbox"
    }
    qemu = {
      version = "1.0.2"
      source = "github.com/hashicorp/qemu"
    }
  }
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }
source "googlecompute" "googlebox" {
  account_file        = var.account_file
  disk_size           = "50"
  image_family        = var.image_family
  image_licenses      = [""]
  image_name          = "${var.image_name}-${local.timestamp}"
  project_id          = var.project_id
  source_image_family = var.source_image
  ssh_username        = "packer"
  zone                = var.project_zone
}

# source "virtualbox-iso" "kali-generate-GCP" {
#   boot_command            = ["<esc><wait>", "install <wait>", "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ", "locale=en_US ", "keymap=us ", "hostname=kali ", "domain='' ", "<enter>"]
#   cpus                    = "2"
#   guest_additions_mode    = "disable"
#   guest_os_type           = "Debian_64"
#   http_directory          = "http"
#   iso_checksum_type       = "${var.iso_checksum_type}"
#   iso_checksum            = "${var.iso_checksum}"
#   iso_url                 = "${var.iso_url}"
#   boot_key_interval       = "10ms"
#   boot_wait               = "3s"
#   communicator            = "ssh"
#   memory                  = "2048"
#   shutdown_command        = "echo 'packer' | sudo -S shutdown -P now"
#   ssh_password            = "vagrant"
#   ssh_timeout             = "60m"
#   ssh_username            = "vagrant"
#   vboxmanage              = [["modifyvm", "{{ .Name }}", "--clipboard-mode", "bidirectional"], ["modifyvm", "{{ .Name }}", "--draganddrop", "bidirectional"]]
#   virtualbox_version_file = ""
# }
# source "qemu" "kali-generate-GCP" {
#   accelerator       = "kvm"
#   boot_command      = ["<esc><wait>", "install <wait>", "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ", "locale=en_US ", "keymap=us ", "hostname=kali ", "domain='' ", "<enter>"]
#   boot_key_interval = "10ms"
#   boot_wait         = "3s"
#   communicator      = "ssh"
#   disk_interface    = "virtio"
#   disk_size         = 20000
#   format            = "raw"
#   headless          = false
#   http_port_max     = 9001
#   http_port_min     = 9001
#   iso_checksum      = "${var.iso_checksum}"
#   iso_checksum_type = "${var.iso_checksum_type}"
#   iso_url           = "${var.iso_url}"
#   net_device        = "virtio-net"
#   output_directory  = "output"
#   qemuargs          = [["-m", "4096"], ["-smp", "2"], ["-display", "gtk"]]
#   shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
#   shutdown_timeout  = "30m"
#   ssh_password      = "toor"
#   ssh_username      = "root"
#   ssh_wait_timeout  = "2h"
#   vm_name           = "disk.raw"
# }

build {
  sources = ["source.googlecompute.googlebox"]
  provisioner "shell" {
    environment_vars = ["PUBLIC_KEY=${var.public_key}"]
    execute_command  = "echo 'vagrant' | {{ .Vars }} sudo -S bash -euxo pipefail '{{ .Path }}'"
    script           = "/scripts/inject-ssh-key.sh"
    script           = "/scripts/install-google-cloud-environment.sh"
  }
  post-processors {
    post-processor "vagrant" {
      vagrantfile_template = "../vagrant/Vagrantfile"
    }
    post-processor "compress" {
      output = "output/disk.raw.tar.gz"
    }
    post-processor "googlecompute-import" {
      account_file = var.account_file
      bucket       = var.google_bucket
      image_family = var.image_family
      image_name   = "${var.image_name}-${local.timestamp}"
      project_id   = var.project_id
    }
    post-processor "vagrant-cloud" {
      access_token = "${var.vagrant_cloud_token}"
      box_tag      = "${var.vagrant_cloud_box}"
      version      = "${var.vagrant_cloud_version}"
    }
  }
}
  