variable "account_file" {
  type = string 
  sensitive = true
}
variable "project_id" {
  type = string
}
variable "project_region" {
    type = string 
}
variable "project_zone" {
    type = string 

}
variable "image_name" {
    type = string 

}
variable "machine_type" {
    type = string 

}
variable "source_image" {
    type = string 

}
variable "ssh_username" {
  type = string 
  sensitive = true
}
variable "cloud_box" {
  type    = string
  default = ""
}

variable "cloud_token" {
  type    = string
  default = ""
}

variable "cloud_version" {
  type    = string
  default = ""
}

variable "iso_checksum" {
  type    = string
  default = "172b24b051311f40c8da05f346ec036ee373e0b1eed19b6db31252bd05a9a0f8"
}

variable "iso_checksum_type" {
  type    = string
  default = "SHA256sum"
}

variable "iso_url" {
  type    = string
  default = "https://cdimage.kali.org/kali-2022.1/kali-linux-2022.1-live-amd64.iso"
}

variable "public_key" {
  type    = string
  sensitive = true
  default = ""
}
