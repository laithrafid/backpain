resource "random_id" "project_id" {
  byte_length = 5
}

locals {
  project_id = "kali-${random_id.project_id.hex}"
}

resource "google_folder" "stg" {
  display_name = "kali-stg"
  parent       = "organizations/${var.organization_id}"
}

module "project-factory" {
  source               = "terraform-google-modules/project-factory/google"
  version              = "12.0.0"
  project_id           = local.project_id
  name                 = local.project_id
  org_id               = var.organization_id
  folder_id            = google_folder.stg.id
  billing_account      = var.billing_account
  activate_apis        = [
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "storage-api.googleapis.com",
    "servicemanagement.googleapis.com",
    "storage-component.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "sourcerepo.googleapis.com"
  ]
  depends_on = [
    google_folder.stg
  ]
}
module "service-accounts" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "4.1.1"
  depends_on    = [module.project-factory]
  project_id    = module.project-factory.project_id
  names         = var.names
  generate_keys = var.generate_keys
  project_roles = [
    "${module.project-factory.project_name}=>roles/viewer",
    "${module.project-factory.project_name}=>roles/storage.objectViewer",
    "${module.project-factory.project_name}=>roles/compute.instanceAdmin.v1",
    "${module.project-factory.project_name}=>roles/iam.serviceAccountUser",
    "${module.project-factory.project_name}=>roles/iam.serviceAccountTokenCreator",
    "${module.project-factory.project_name}=>roles/iap.tunnelResourceAccessor"
  ]
}

resource "google_storage_bucket" "kali-image" {
  name          = "kali-image-project-10"
  location      = var.project_region
  project       = module.project-factory.project_id
  storage_class = "REGIONAL"
  force_destroy = true
}