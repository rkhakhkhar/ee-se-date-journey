variable "project_id" {
  description = "Google Project ID"
  type = string
  default = "ee-india-se-data"
}

variable "region" {
  description = "Google Cloud Region"
  type = string
  default = "US"
}
variable "bucket_name" {
  description = "GCS bucket name"
  type = string
  default = "se-data-landing-ravi"
}