variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region to deploy the Cloud Run service"
  type        = string
  default     = "us-central1"
}

variable "service_name" {
  description = "The name of the Cloud Run service"
  type        = string
  default     = "node-ts-service"
}

variable "github_repo_url" {
  description = "The GitHub repository URL"
  type        = string
  default     = "https://github.com/marcuwynu23/node-typescript-modular-boilerplate"
}

variable "developer_connect_connection_name" {
  description = "The name of the Developer Connect connection"
  type        = string
  default     = "github-connection"
}

variable "github_owner" {
  description = "The GitHub repository owner/organization"
  type        = string
  default     = "marcuwynu23"
}

variable "github_repo_name" {
  description = "The GitHub repository name"
  type        = string
  default     = "node-typescript-modular-boilerplate"
}

variable "github_ref" {
  description = "The GitHub reference (branch, tag, or commit) to use"
  type        = string
  default     = "main"
}

variable "service_account_email" {
  description = "The service account email for Cloud Build and Cloud Run"
  type        = string
  default     = ""
}
