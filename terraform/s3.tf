# ----------------------------------------------
# S3 Bucket
# ----------------------------------------------
resource "aws_s3_bucket" "dwh" {
  bucket        = "${var.project_name}-datawarehouse"
  force_destroy = true
}

resource "aws_s3_bucket" "log" {
  bucket        = "${var.project_name}-log"
  force_destroy = true
}


# ----------------------------------------------
# S3 Bucket Enctyption Configure
# ----------------------------------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "dwh" {
  bucket = aws_s3_bucket.dwh.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "log" {
  bucket = aws_s3_bucket.log.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# ----------------------------------------------
# S3 Bucket Public Access Block
# ----------------------------------------------
resource "aws_s3_bucket_acl" "dwh" {
  bucket = aws_s3_bucket.dwh.bucket
  acl    = "private"
}

resource "aws_s3_bucket_acl" "log" {
  bucket = aws_s3_bucket.log.bucket
  acl    = "private"
}


resource "aws_s3_bucket_public_access_block" "dwh" {
  bucket                  = aws_s3_bucket.dwh.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
