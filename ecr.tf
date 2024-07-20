resource "aws_ecr_repository" "flow_ecr" {
  name                 = "flow-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}