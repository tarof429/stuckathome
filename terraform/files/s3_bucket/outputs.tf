output "website_domain" {
  value = aws_s3_bucket_website_configuration.mybucket_website.website_endpoint
}