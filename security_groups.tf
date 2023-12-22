resource "aws_security_group" "rds" {
  name        = "rds-flow-${var.environment}"
  description = "For RDS ${var.environment}"

  vpc_id = aws_vpc.flow_vpc.id
  tags = {
    Name = "flow-${var.environment}"
  }
}

resource "aws_security_group_rule" "mysql_rds_default" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds.id
  source_security_group_id = aws_vpc.flow_vpc.default_security_group_id
}

resource "aws_security_group_rule" "mysql_rds_web_server" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds.id
  source_security_group_id = aws_security_group.web_server.id
}

resource "aws_security_group" "web_server" {
  name        = "flow-${var.environment}-web-servers"
  description = "For Web servers ${var.environment}"
  vpc_id      = aws_vpc.flow_vpc.id

  tags = {
    Name = "flow-${var.environment}"
  }
}

resource "aws_security_group_rule" "web_server-internet-access" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  security_group_id = aws_security_group.web_server.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "http_web_server" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.web_server.id
  cidr_blocks       = [aws_vpc.flow_vpc.cidr_block]
}

resource "aws_security_group_rule" "https_web_server" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.web_server.id
  cidr_blocks       = [aws_vpc.flow_vpc.cidr_block]
}