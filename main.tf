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

# S3 Bucket representing customer workload asset storage
resource "aws_s3_bucket" "audit_sample_bucket" {
  bucket_prefix = "jivox-workload-audit-"

  tags = {
    Name        = "Jivox-Audit-Verification-Bucket"
    Customer    = "Jivox"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Compliance  = "AWS-MSP-v7.1"
    ReleaseId   = "REL-2026-001"
    AuditStatus = "Audited-Release"
  }
}

# Security best practice: Enable versioning
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.audit_sample_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Security best practice: Server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.audit_sample_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

output "bucket_name" {
  value       = aws_s3_bucket.audit_sample_bucket.id
  description = "Deployed AWS S3 Bucket Name"
}

output "bucket_arn" {
  value       = aws_s3_bucket.audit_sample_bucket.arn
  description = "Deployed AWS S3 Bucket ARN"
}

