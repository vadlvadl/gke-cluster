terraform {
  backend "gcs" {
    bucket = "tf-storage-anl-test-lv"
    prefix = "gke-cluster/terraform/network"
    credentials = "../../creds/terraform@anl-test.json"
  }
}