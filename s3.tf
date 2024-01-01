resource "aws_s3_bucket" "flow_s3" {
  bucket = var.environment == "dev" ? "flow-dev.nsar-tech.co.uk" : "flow.nsar-tech.co.uk"

  tags = {
    Name        = "flow-${var.environment}-s3-bucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_website_configuration" "flow_s3_website" {
  bucket = aws_s3_bucket.flow_s3.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_cors_configuration" "flow_s3_cors_config" {
  bucket = aws_s3_bucket.flow_s3.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE"]
    allowed_origins = var.environment == "dev" ? ["flow-dev.nsar-tech.co.uk"] : ["flow.nsar-tech.co.uk"]
    max_age_seconds = 3000
  }
}

# @todo FLOW-16: Remove public access and implement signatures via CF distribution
# resource "aws_s3_bucket_public_access_block" "flow_s3_public_access" {
#   bucket = aws_s3_bucket.flow_s3.id

#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

data "aws_iam_policy_document" "flow_s3_policy_document" {
  statement {
    sid = "FlowPublicReadOnly"

    effect = "Allow"

    principals {
      type = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.flow_s3.arn}/*",
    ]
  }
}

# @todo FLOW-16: Remove public access and implement signatures via CF distribution
# data "aws_iam_policy_document" "flow_s3_policy_document" {
#   statement {
#     sid = "AllowCloudFrontServicePrincipalReadOnly"

#     effect = "Allow"

#     principals {
#       type = "Service"
#       identifiers = ["cloudfront.amazonaws.com"]
#     }

#     actions = [
#       "s3:GetObject",
#     ]

#     resources = [
#       "${aws_s3_bucket.flow_s3.arn}/*",
#     ]

#     condition {
#       test = "StringEquals"
#       values = [aws_cloudfront_distribution.flow_cloudfront_distribution.arn]
#       variable = "AWS:SourceArn"
#     }
#   }

#   statement {
#     sid = "AllowLegacyOAIReadOnly"

#     effect = "Allow"

#     principals {
#       type = "AWS"
#       identifiers = ["arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_control.flow_cloudfront_oac.id}"]
#     }

#     actions = [
#       "s3:GetObject",
#     ]

#     resources = [
#       "${aws_s3_bucket.flow_s3.arn}/*",
#     ]
#   }
# }

resource "aws_s3_bucket_policy" "flow_s3_bucket_policy" {
  bucket = aws_s3_bucket.flow_s3.id
  policy = data.aws_iam_policy_document.flow_s3_policy_document.json
}