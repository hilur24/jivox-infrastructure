terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "Target AWS Region"
}

variable "environment" {
  type        = string
  default     = "production"
  description = "Deployment Environment"
}

# Production S3 Bucket for customer workload asset storage
resource "aws_s3_bucket" "workload_asset_bucket" {
  bucket_prefix = "jivox-prod-assets-"

  tags = {
    Name        = "jivox-prod-asset-storage"
    Customer    = "Jivox"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "Workload-Infrastructure"
  }
}

# Security best practice: Enable versioning
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.workload_asset_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Security best practice: Server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.workload_asset_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Security best practice: Block all public access
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.workload_asset_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "bucket_name" {
  value       = aws_s3_bucket.workload_asset_bucket.id
  description = "Deployed AWS S3 Bucket Name"
}

output "bucket_arn" {
  value       = aws_s3_bucket.workload_asset_bucket.arn
  description = "Deployed AWS S3 Bucket ARN"
}
