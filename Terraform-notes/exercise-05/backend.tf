terraform {
  backend "s3" {
    bucket = "mbadwa-aws-cicd-vproartifact"
    key = "terraform/backend"
    region = "us-east-1"
  }
}