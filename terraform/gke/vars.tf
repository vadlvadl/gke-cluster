variable "gcp_project_id" {
  type    = string
  default = "anl-test"
}

variable region {
  description = "location"
  default     = "us-central1"
}

variable "availability_zone_names" {
  type = list(string)
  default = [
    "us-central1-a",
    "us-central1-b",
    "us-central1-c"
  ]
}

variable "k8s_master_version" {
  default = "1.18.18-gke.1100"
}

variable "k8s_node_version" {
  description = "Node version"
  default     = "1.18.18-gke.1100"
}

variable "resource_labels" {
  type = map
  default =  {
    name        = "test"
    environment = "anl"
  }
}

variable "network_name" {
  default = "test-network"
}

variable "subnetwork_name" {
  default = "test-subnetwork"
}

variable "ip_range_pods" {
  default = "192.168.64.0/22"
}

variable "ip_range_services" {
  default = "192.168.1.0/24"
}

variable "non_masquerade_cidrs" {
  type = list(string)
  default = ["10.2.8.0/24"]
}