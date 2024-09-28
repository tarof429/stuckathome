provider "aws" {
  region = local.myregion
}

locals {
  myregion = "us-west-2"
}

resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucket_name

  tags = {
    "Name" = "mybucket"
  }

  force_destroy = true
}

resource "aws_s3_bucket_versioning" "mybucket_versioning" {
  bucket = aws_s3_bucket.mybucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "mybucket_bucket_policy" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "mybucket_website" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "allow_public_access" {
  bucket     = aws_s3_bucket.mybucket.id
  policy     = data.aws_iam_policy_document.allow_public_read.json
  depends_on = [aws_s3_bucket_public_access_block.mybucket_bucket_policy]
}

data "aws_iam_policy_document" "allow_public_read" {

  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.mybucket.arn}/*"
    ]
  }
}