resource "google_bigquery_table" "movie_table" {
  dataset_id          = google_bigquery_dataset.movie_dataset.dataset_id
  table_id            = "movies_dataset_raw"
  deletion_protection = false
  schema              = file("${path.module}/movie_table_schema.json")

  depends_on = [
    google_bigquery_dataset.movie_dataset
  ]
}