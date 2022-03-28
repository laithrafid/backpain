## Requirements
1. install terraform  (Terraform v1.1.7)
2. install gcloud 
3. gcloud auth login 
4. copy terraform.tfvars
 `cp terraform.tfvars.template terraform.tfvars`
5. gcloud auth print-access-token
6. fill all variables terraform.tfvars

## How to Run
then workaround an issue with root module of services_accounts in this , i'm lazy to put these modules in seprate folders

so Run As below
```
terraform init 
terraform apply -target=module.project-factory --var-file=terraform.tfvars --auto-approve
terraform apply --var-file=terraform.tfvars --auto-approve
terraform output -raw key > ../kali.json
```

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.5 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 4.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.15.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_project-factory"></a> [project-factory](#module\_project-factory) | terraform-google-modules/project-factory/google | 12.0.0 |
| <a name="module_service-accounts"></a> [service-accounts](#module\_service-accounts) | terraform-google-modules/service-accounts/google | 4.1.1 |

## Resources

| Name | Type |
|------|------|
| [google_folder.stg](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder) | resource |
| [random_id.project_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_token"></a> [access\_token](#input\_access\_token) | access\_token you can get fro gcloud auth print-access-token | `string` | `""` | no |
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | billing account for your google cloud to associated with this project | `string` | `""` | no |
| <a name="input_bucket_force_destroy"></a> [bucket\_force\_destroy](#input\_bucket\_force\_destroy) | do you want to force delete bucket created with this project when project deleted? | `bool` | `false` | no |
| <a name="input_consumer_quotas"></a> [consumer\_quotas](#input\_consumer\_quotas) | n/a | <pre>list(object({<br>    service = string,<br>    metric  = string,<br>    limit   = string,<br>    value   = string,<br>  }))</pre> | `[]` | no |
| <a name="input_generate_keys"></a> [generate\_keys](#input\_generate\_keys) | Generate keys for service accounts. | `bool` | `false` | no |
| <a name="input_names"></a> [names](#input\_names) | name for service account to be added before@ | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | you org id from google cloud account | `string` | `""` | no |
| <a name="input_project_region"></a> [project\_region](#input\_project\_region) | default region for this project | `string` | `"northamerica-northeast1"` | no |
| <a name="input_project_zone"></a> [project\_zone](#input\_project\_zone) | default zone for this project | `string` | `"northamerica-northeast1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_email"></a> [email](#output\_email) | Service account email (for single use). |
| <a name="output_enabled_apis"></a> [enabled\_apis](#output\_enabled\_apis) | Enabled APIs in the project |
| <a name="output_iam_email"></a> [iam\_email](#output\_iam\_email) | IAM-format service account email (for single use). |
| <a name="output_key"></a> [key](#output\_key) | Service account key (for single use). |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | The ID of the created factory project |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | The ID of the created factory project |
