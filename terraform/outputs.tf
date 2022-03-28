output "project_id" {
  value       = module.project-factory.project_id
  description = "The ID of the created factory project"
}
output "project_name" {
  value       = module.project-factory.project_name
  description = "The ID of the created factory project"
}

output "enabled_apis" {
  description = "Enabled APIs in the project"
  value       = module.project-factory.enabled_apis
}

output "email" {
  description = "Service account email (for single use)."
  value       = module.service-accounts.email
}

output "iam_email" {
  description = "IAM-format service account email (for single use)."
  value       = module.service-accounts.iam_email
}

output "key" {
  description = "Service account key (for single use)."
  sensitive   = true
  value       = module.service-accounts.key
}
output "bucket" {
  description = "google cloud bucket"
  value = google_storage_bucket.kali-image
}