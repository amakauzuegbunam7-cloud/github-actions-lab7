terraform {
required_providers {
aws = {
source  = "hashicorp/aws"
version = "~> 5.0"
}
random = {
source  = "hashicorp/random"
version = "~> 3.0"
}
}
}

provider "aws" {
region = "eu-west-2"
}

variable "bucket_suffix" {
description = "Unique suffix for bucket name (use your initials)"
type        = string
default     = "va"
}

variable "environment" {
description = "Deployment environment"
type        = string
default     = "dev"
}

resource "random_id" "bucket_suffix" {
byte_length = 4
}

resource "aws_s3_bucket" "demo" {
bucket = "cloudburst-${var.environment}-${var.bucket_suffix}-${random_id.bucket_suffix.hex}"

tags = {
Name        = "CloudBurst ${var.environment} Bucket"
Environment = var.environment
ManagedBy   = "terraform"
DeployedBy  = "github-actions"
TestTag     = "pr-comment-test"
}
}

output "bucket_name" {
description = "Name of the created S3 bucket"
value       = aws_s3_bucket.demo.bucket
}

output "environment" {
description = "Deployment environment"
value       = var.environment
}
