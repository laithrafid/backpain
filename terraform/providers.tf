terraform {
  cloud {
    organization = "bayt"
    hostname     = "app.terraform.io"
    workspaces {
      name = "kali-linux"
      //tags = ["APIs:digitalocean"]
    }
  }
  required_version = ">= 0.13"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.5"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.5"
    }
  }
}
provider "google-beta" {
  access_token = var.access_token
  region = var.project_region
  zone   = var.project_zone
}
provider "google" {
  access_token = var.access_token
  region = var.project_region
  zone   = var.project_zone
}
