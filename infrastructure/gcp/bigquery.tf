resource "google_bigquery_dataset" "events_dataset" {
  dataset_id                  = "ema_${var.environment}_events"
  friendly_name               = "Enterprise Analytics Events (${var.environment})"
  description                 = "Dataset for storing ingested analytics events from AWS Fargate FastAPI service."
  location                    = "EU"
  delete_contents_on_destroy  = false

  labels = {
    env       = var.environment
    managed_by = "terraform"
  }
}

resource "google_bigquery_table" "raw_events_table" {
  dataset_id          = google_bigquery_dataset.events_dataset.dataset_id
  table_id            = "raw_events"
  deletion_protection = false

  schema = <<EOF
[
  {
    "name": "id",
    "type": "STRING",
    "mode": "REQUIRED",
    "description": "Unique UUID for the ingested event"
  },
  {
    "name": "service",
    "type": "STRING",
    "mode": "REQUIRED",
    "description": "Name of the originating service"
  },
  {
    "name": "event",
    "type": "STRING",
    "mode": "REQUIRED",
    "description": "Event name or action type"
  },
  {
    "name": "severity",
    "type": "STRING",
    "mode": "REQUIRED",
    "description": "Severity level: info, warning, error, or critical"
  },
  {
    "name": "description",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "Optional detailed event context or trace message"
  },
  {
    "name": "created_at",
    "type": "TIMESTAMP",
    "mode": "REQUIRED",
    "description": "Timestamp when the event was recorded"
  }
]
EOF
}
# Service Account for AWS ECS FastAPI backend
resource "google_service_account" "fastapi_sa" {
  account_id   = "ema-${var.environment}-fastapi-sa"
  display_name = "EMA FastAPI Service Account (${var.environment})"
  description  = "Service Account used by AWS ECS Fargate FastAPI service to stream events to BigQuery."
}

# Grant BigQuery Data Editor (allows streaming inserts)
resource "google_project_iam_member" "bq_data_editor" {
  project = var.gcp_project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.fastapi_sa.email}"
}

# Grant BigQuery Job User (allows running query jobs for list endpoint)
resource "google_project_iam_member" "bq_job_user" {
  project = var.gcp_project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.fastapi_sa.email}"
}