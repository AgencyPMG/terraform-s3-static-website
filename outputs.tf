output "bucket_name" {
  value = aws_s3_bucket.this.id
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}

output "cloudfront_url" {
  value = "https://${aws_route53_record.this.fqdn}"
}

output "cloudfront_arn" {
  value = aws_cloudfront_distribution.this.arn
}
