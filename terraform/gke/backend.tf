terraform {
  backend "gcs" {
    bucket = "tf-storage-anl-test-lv"
    prefix = "gke-cluster/terraform/gke"
    credentials = "../../creds/terraform@anl-test.json"
  }
}