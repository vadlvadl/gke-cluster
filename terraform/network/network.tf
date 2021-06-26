resource "google_compute_network" "custom" {
  project = var.project
  name                    = "test-network"
  auto_create_subnetworks = false
}

output "network_name" {
  value = google_compute_network.custom.name
}

output "network_id" {
  value = google_compute_network.custom.id
}

output "network_link" {
  value = google_compute_network.custom.self_link
}