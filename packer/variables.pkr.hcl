variable "access_token" {
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