resource "aws_s3_bucket" "backend_s3" {
  bucket        = "${var.prefix}-tfstate"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "versioning_s3" {
  bucket = aws_s3_bucket.backend_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_s3" {
  bucket = aws_s3_bucket.backend_s3.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}