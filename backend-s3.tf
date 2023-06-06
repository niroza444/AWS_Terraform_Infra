terraform {
  backend "s3" {
    bucket = "terra-cloud_project-state11"
    key    = "terraform/backend"
    region = "us-east-2"
  }
}