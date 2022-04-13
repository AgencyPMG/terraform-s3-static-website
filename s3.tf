resource "aws_s3_bucket" "this" {
  bucket = local.hostname
  acl    = "public-read"

  website {
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

  tags = {
    Client = var.name
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
