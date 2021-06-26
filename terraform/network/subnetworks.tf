resource "google_compute_subnetwork" "primary_cluster" {
  project = var.project

  name          = "test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.custom.id

  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "192.168.1.0/24"
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "192.168.64.0/22"
  }
}

output "subnetwork_primary_name" {
  value = google_compute_subnetwork.primary_cluster.name
}

output "subnetwork_primary_id" {
  value = google_compute_subnetwork.primary_cluster.id
}

output "subnetwork_primary_link" {
  value = google_compute_subnetwork.primary_cluster.self_link
}

output "subnetwork_primary_main_range_ip" {
  value = google_compute_subnetwork.primary_cluster.ip_cidr_range
}

output "subnetwork_primary_services_range_ip" {
  value = google_compute_subnetwork.primary_cluster.secondary_ip_range[0].ip_cidr_range
}

output "subnetwork_primary_pod_range_ip" {
  value = google_compute_subnetwork.primary_cluster.secondary_ip_range[1].ip_cidr_range
}