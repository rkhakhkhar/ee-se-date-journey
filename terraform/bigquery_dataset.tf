resource "google_bigquery_dataset" "movie_dataset" {
  dataset_id    = "movies_data_ravi"
  friendly_name = "Movie Dataset for Ravi"
  location      = var.region
}