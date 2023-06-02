resource "aws_s3_bucket" "this" {
  bucket = local.hostname

  tags = {
    Client = var.name
  }
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "public-read"
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

  index_document = "index.html"
  error_document = "error.html"
  routing_rules  = <<EOF
[
    {
        "Condition": {
            "HttpErrorCodeReturnedEquals": "404"
        },
        "Redirect": {
            "HostName": "www.pmg.com",
            "Protocol": "https",
            "HttpRedirectCode": "303",
            "ReplaceKeyWith": "/"
        }
    }
]
EOF
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
