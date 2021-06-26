locals {
  oauth_scopes = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/service.management",
  ]

  general_workload_type = "general"

  //  we need only two locations: zone-a and zone-c
  node_locations = join(",", [
    element(var.availability_zone_names, 0),
    element(var.availability_zone_names, 2)
    ]
  )
}

module "gke-primary" {
  providers = {
    kubernetes = kubernetes.primary
  }
  source                            = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"
  version                           = "14.2.0"
  project_id                        = var.gcp_project_id
  name                              = "primary-01"
  description                       = "Testing cluster"
  kubernetes_version                = var.k8s_master_version
  initial_node_count                = "0"
  create_service_account            = true
  region                            = var.region
  zones                             = var.availability_zone_names
  enable_shielded_nodes             = true
  network                           = data.google_compute_network.cluster.name
  subnetwork                        = data.google_compute_subnetwork.main.name
//  network_project_id                = "rc-shared-vpc-prod"
  master_ipv4_cidr_block            = "10.2.252.0/28"
  ip_range_pods                     = var.ip_range_pods
  ip_range_services                 = var.ip_range_services
  configure_ip_masq                 = true
  non_masquerade_cidrs              = var.non_masquerade_cidrs
  identity_namespace                = "${var.gcp_project_id}.svc.id.goog"
  node_metadata                     = "GKE_METADATA_SERVER"
  default_max_pods_per_node         = 110
  http_load_balancing               = true
  horizontal_pod_autoscaling        = false
  network_policy                    = false
  monitoring_service                = "none"
  logging_service                   = "logging.googleapis.com/kubernetes"
  istio                             = false
  cloudrun                          = false
  disable_legacy_metadata_endpoints = true
  deploy_using_private_endpoint     = true
  enable_private_endpoint           = true
  enable_private_nodes              = true
  remove_default_node_pool          = true
  cluster_resource_labels           = var.resource_labels
  maintenance_start_time            = "2021-01-01T13:00:00Z"
  maintenance_end_time	            = "2021-01-01T19:00:00Z"
  maintenance_recurrence            = "FREQ=WEEKLY;BYDAY=FR,SA,SU"

  node_pools = [
    {
      name               = "cassandra-multidc-pool-a"
      machine_type       = "e2-small"
      node_locations     = local.node_locations
      initial_node_count = 0
      node_count         = 0
      min_count          = 0
      max_count          = 3
      local_ssd_count    = 0
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS"
      autoscaling        = true
      auto_repair        = true
      auto_upgrade       = false
      preemptible        = true
      version            = var.k8s_node_version
      node_metadata      = "GKE_METADATA_SERVER"
    }
  ]

  node_pools_oauth_scopes = {
    all               = local.oauth_scopes
    default-node-pool = local.oauth_scopes
  }

  master_authorized_networks = [
    {
      display_name = "internal-network"
      cidr_block   = "10.2.0.0/16"
    }
  ]

  node_pools_taints = {
    all = []

    cassandra-multidc-pool-a = [
      {
        key    = "cassandra"
        value  = "primary"
        effect = "NO_SCHEDULE"
      }
    ]
  }

  node_pools_labels = {
    all = {}

    cassandra-multidc-pool-a = {
      workload-type = "cassandra-multi"
      namespace     = "primary"
    }
  }
}
