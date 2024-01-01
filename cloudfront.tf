locals {
  s3_origin_id = "flow-s3-origin-id"
}

resource "aws_cloudfront_cache_policy" "flow_cloudfront_cache_policy" {
  name        = "flow-${var.environment}-cache-policy"
  default_ttl = 50
  max_ttl     = 100
  min_ttl     = 1

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "all"
    }

    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "all"
    }
  }
}

resource "aws_cloudfront_origin_request_policy" "flow_cloudfront_origin_request_policy" {
  name = "flow-${var.environment}-origin-request-policy"

  cookies_config {
    cookie_behavior = "all"
  }

  headers_config {
    header_behavior = "allViewer"
  }
  query_strings_config {
    query_string_behavior = "all"
  }
}

# @todo FLOW-16: Remove public access and implement signatures via CF distribution
# resource "aws_cloudfront_origin_access_control" "flow_cloudfront_oac" {
#   name                              = "flow-oac-policy"
#   origin_access_control_origin_type = "s3"
#   signing_behavior                  = "always"
#   signing_protocol                  = "sigv4"
# }

resource "aws_cloudfront_distribution" "flow_cloudfront_distribution" {
  origin {
    domain_name = aws_s3_bucket_website_configuration.flow_s3_website.website_endpoint
    origin_id   = local.s3_origin_id
    # origin_access_control_id = aws_cloudfront_origin_access_control.flow_cloudfront_oac.id

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Flow UI distribution for S3 static site"
  default_root_object = "index.html"

  aliases = var.environment == "dev" ? ["flow-dev.nsar-tech.co.uk"] : ["flow.nsar-tech.co.uk"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    cache_policy_id = aws_cloudfront_cache_policy.flow_cloudfront_cache_policy.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.flow_cloudfront_origin_request_policy.id

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["GB"]
    }
  }

  tags = {
    Name        = "flow-${var.environment}-cloudfront"
    Environment = var.environment
  }

  viewer_certificate {
    acm_certificate_arn = "arn:aws:acm:us-east-1:308697347926:certificate/6a2684c2-f4b2-4377-b12f-a74ec34a8bb2"
    ssl_support_method  = "sni-only"
  }
}
