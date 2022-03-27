variable "access_token" {
  type = string
  sensitive = true
  description = "access_token you can get fro gcloud auth print-access-token"
  default = ""
}
variable "project_region" {
  type        = string
  description = "default region for this project"
  default     = "northamerica-northeast1"
}
variable "project_zone" {
  type        = string
  description = "default zone for this project"
  default     = "northamerica-northeast1-a"
}
variable "organization_id" {
  type        = string
  description = "you org id from google cloud account"
  default     = ""
}
variable "billing_account" {
  type        = string
  description = "billing account for your google cloud to associated with this project"
  sensitive   = true
  default     = ""
}
variable "bucket_force_destroy" {
  type        = bool
  description = "do you want to force delete bucket created with this project when project deleted?"
  default     = false
}
variable "consumer_quotas" {
  type = list(object({
    service = string,
    metric  = string,
    limit   = string,
    value   = string,
  }))
  default = []
}
variable "names" {
  type        = list(string)
  description = "name for service account to be added before@"
  default     = [""]
}
variable "generate_keys" {
  type        = bool
  description = "Generate keys for service accounts."
  default     = false
}