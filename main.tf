provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable required GCP APIs
locals {
  required_apis = [
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
    "iam.googleapis.com"
  ]
}

resource "google_project_service" "required_apis" {
  for_each           = toset(local.required_apis)
  service            = each.key
  disable_on_destroy = false
}

# Random suffix for unique service name
resource "random_id" "suffix" {
  byte_length = 4
}

# Get project number
data "google_project" "project" {
  project_id = var.project_id
}

# IAM permissions for Cloud Build to deploy to Cloud Run
resource "google_project_iam_member" "cloudbuild_run_admin" {
  project    = var.project_id
  role       = "roles/run.admin"
  member     = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
  depends_on = [google_project_service.required_apis["cloudbuild.googleapis.com"]]
}

# Cloud Run V2 Service
resource "google_cloud_run_v2_service" "default" {
  name                = "${var.service_name}-${random_id.suffix.hex}"
  location            = var.region
  ingress             = "INGRESS_TRAFFIC_ALL"
  deletion_protection = false

  template {
    scaling {
      max_instance_count = 1
    }

    containers {
      image = "nginx:alpine"
      ports {
        container_port = 80
      }
      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
        cpu_idle = true
      }
    }
  }

  depends_on = [google_project_service.required_apis]
}

# Allow unauthenticated access
resource "google_cloud_run_v2_service_iam_member" "noauth" {
  location = google_cloud_run_v2_service.default.location
  name     = google_cloud_run_v2_service.default.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
