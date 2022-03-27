packer {

  required_plugins {
    googlecompute = {
      version = "1.0.0" 
      source  = "github.com/hashicorp/googlecompute"
    }
    virtualbox-iso = {
      version = ""
      source  = ""
    }
    qemu = {
      version = ""
      source = ""
    }
  }
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }
source "googlecompute" "googlebox" {
  account_file        = var.account_file
  disk_size           = "20"
  image_family        = "kali"
  image_licenses      = [""]
  image_name          = "kali-rolling-${local.timestamp}"
  project_id          = 
  source_image_family = "kali-rolling-gcpized"
  ssh_username        = "packer"
  zone                = "us-central1-a"
}

source "virtualbox-iso" "kali-generate-GCP" {
  boot_command            = ["<esc><wait>", "install <wait>", "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ", "locale=en_US ", "keymap=us ", "hostname=kali ", "domain='' ", "<enter>"]
  cpus                    = "2"
  guest_additions_mode    = "disable"
  guest_os_type           = "Debian_64"
  http_directory          = "http"
  iso_checksum_type       = "${var.iso_checksum_type}"
  iso_checksum            = "${var.iso_checksum}"
  iso_url                 = "${var.iso_url}"
  boot_key_interval       = "10ms"
  boot_wait               = "3s"
  communicator            = "ssh"
  memory                  = "2048"
  shutdown_command        = "echo 'packer' | sudo -S shutdown -P now"
  ssh_password            = "vagrant"
  ssh_timeout             = "60m"
  ssh_username            = "vagrant"
  vboxmanage              = [["modifyvm", "{{ .Name }}", "--clipboard-mode", "bidirectional"], ["modifyvm", "{{ .Name }}", "--draganddrop", "bidirectional"]]
  virtualbox_version_file = ""
}
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

  sources = ["source.virtualbox-iso.kali-generate-GCP"]
  provisioner "shell" {
    environment_vars = ["PUBLIC_KEY=${var.public_key}"]
    script           = "${path.root}/../vagrant/scripts/inject-ssh-key.sh"
    script = "${path.root}/../scripts/install-google-cloud-environment.sh"
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -S bash -euxo pipefail '{{ .Path }}'"
    scripts         = ["scripts/vagrant.sh", "scripts/minimize.sh"]
  }
  post-processors {
    post-processor "compress" {
      output = "output/disk.raw.tar.gz"
    }
    post-processor "vagrant" {
      vagrantfile_template = "../vagrant/Vagrantfile"
    }
    post-processor "googlecompute-import" {
      account_file = "${path.root}/sa.json"
      bucket       = "REPLACE_ME"
      image_family = "kali-rolling-gcpized"
      image_name   = "kali-rolling-${local.timestamp}"
      project_id   = var.project_id
    }
    post-processor "vagrant-cloud" {
      access_token = "${var.vagrant_cloud_token}"
      box_tag      = "${var.vagrant_cloud_box}"
      version      = "${var.vagrant_cloud_version}"
    }
    post-processor "googlecompute-export" {
      paths = [
        "gs://kali-image-project-10/"
      ]
      keep_input_artifact = true
    }
  }
}
  