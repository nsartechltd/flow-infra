resource "aws_vpc" "flow_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "flow-${var.environment}"
  }
}