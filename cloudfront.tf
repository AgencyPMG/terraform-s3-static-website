resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  comment             = "${local.hostname} distribution"
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket_website_configuration.this.website_endpoint
    origin_id   = "s3-bucket"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["SSLv3", "TLSv1"]
    }
  }

  aliases = [
    local.hostname,
  ]

  logging_config {
    bucket          = "pmg-monitoring-${var.env}-alb-logs"
    include_cookies = false
    prefix          = "cloudfront/${var.app}/${var.env}"
  }

  price_class = "PriceClass_100"

  default_cache_behavior {
    target_origin_id       = "s3-bucket"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    min_ttl                = 300
    default_ttl            = 3600
    max_ttl                = 86400
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.cert_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Client = var.name
  }
}
