resource "google_storage_bucket" "data_loader_cloud_function_bucket" {
  name = "data_loader_bucket_ravi"
  location = var.region
}

resource "google_storage_bucket_object" "data_loader_cloud_function_source" {
  name = "index.zip"
  bucket = google_storage_bucket.data_loader_cloud_function_bucket.name
  source = "index.zip"

  depends_on = [
    data.archive_file.data_loader_cloud_function_archive
  ]
}

data "archive_file" "data_loader_cloud_function_archive" {
    type = "zip"
    source_dir = "../movie-data-loader"
    excludes = [".venv"]
    output_path = "${path.module}/index.zip"
}

resource "google_storage_bucket_object" "zip" {
  source       = data.archive_file.data_loader_cloud_function_archive.output_path
  content_type = "application/zip"
  name         = "src-${data.archive_file.data_loader_cloud_function_archive.output_md5}.zip"
  bucket       = google_storage_bucket.data_loader_cloud_function_bucket.name
  depends_on = [
    google_storage_bucket.data_loader_cloud_function_bucket,
    data.archive_file.data_loader_cloud_function_archive
  ]
}

resource "google_cloudfunctions_function" "movie_data_loader" {
  name    = "load_data"
  runtime = "python312"
  region = "us-east1"
  project = var.project_id
  available_memory_mb = 128
  source_archive_bucket = google_storage_bucket.data_loader_cloud_function_bucket.name
  source_archive_object = google_storage_bucket_object.data_loader_cloud_function_source.name
  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = google_storage_bucket.se-data-landing-bucket.name
  }

  environment_variables = {
    TABLE_ID = "${var.project_id}.${google_bigquery_dataset.movie_dataset.dataset_id}.${google_bigquery_table.movie_table.table_id}"
  }
}