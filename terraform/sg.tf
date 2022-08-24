# ----------------------------------------------
# Security Group
# ----------------------------------------------
resource "aws_security_group" "batch" {
  name = "${var.project_name}-batch-sg"

  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "batch_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.batch.id
}
