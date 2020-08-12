locals {
  domain_name_trimmed = trim(data.aws_route53_zone.this.name, ".")
  hostname            = "${var.name}.${local.domain_name_trimmed}"
}

data "aws_route53_zone" "this" {
  zone_id = var.zone_id
}

resource "aws_route53_record" "this" {
  zone_id = var.zone_id
  name    = local.hostname
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = false
  }
}
