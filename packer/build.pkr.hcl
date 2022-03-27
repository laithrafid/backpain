packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}
source "googlecompute" "first_image" {
  access_token            = var.access_token
  image_name              = var.image_name
  machine_type            = var.machine_type
  source_image            = var.source_image
  ssh_username            = var.ssh_username
  temporary_key_pair_type = "rsa"
  temporary_key_pair_bits = 2048
  zone                    = var.project_zone
  disk_size = 50
  project_id              = var.project_id
}

build {
  sources = ["source.googlecompute.first_image"]
  
  
  provisioner "shell" {
        scripts = fileset(".", "scripts/{install,secure}.sh")
    }
  
  
  provisioner "shell" {
    inline = [
      "echo Hello From ${source.type} ${source.name}"
    ]
  }
}