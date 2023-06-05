resource "aws_s3_bucket" "this" {
  bucket = local.hostname

  tags = {
    Client = var.name
  }
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "public-read"

  depends_on = [
    aws_s3_bucket_public_access_block.this,
    aws_s3_bucket_ownership_controls.this,
  ]
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = " error.html"
  }

  routing_rule {
    condition {
      http_error_code_returned_equals = 404
    }

    redirect {
      host_name          = "www.pmg.com"
      protocol           = "https"
      http_redirect_code = "303"
      replace_key_with   = "/"
    }
  }
}

data "aws_iam_policy_document" "bucket" {
  statement {
    sid       = "AllowPublicGet"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  source_json = var.additional_bucket_policy_document
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.bucket
  policy = data.aws_iam_policy_document.bucket.json
}
