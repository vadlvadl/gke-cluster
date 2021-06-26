terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.65.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 1.13.3"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
}

provider "kubernetes" {
  alias                  = "primary"
  load_config_file       = false
  host                   = module.gke-primary.endpoint
  token                  = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(module.gke-primary.ca_certificate)
}

data "google_client_config" "provider" {}

data "google_compute_network" "cluster"{
  project = var.gcp_project_id
  name = var.network_name
}

data "google_compute_subnetwork" "main" {
  project = var.gcp_project_id
  name = var.subnetwork_name
  region = var.region
}