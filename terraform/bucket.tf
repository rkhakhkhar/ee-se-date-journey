resource "google_storage_bucket" "se-data-landing-bucket" {
  location                 = var.region
  name                     = var.bucket_name
  public_access_prevention = "enforced"
}