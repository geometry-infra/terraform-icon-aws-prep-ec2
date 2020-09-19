
//data "aws_vpc" "this" {
//  default = true
//}

resource "aws_security_group" "this" {
  count = var.create_sg && var.create ? 1 : 0
  //  vpc_id = var.vpc_id == "" ? data.aws_default_vpc.this.id : var.vpc_id
  vpc_id = var.vpc_id == "" ? null : var.vpc_id

  //  dynamic "ingress" {
  //    for_each = [
  //      22,   # ssh
  //      7100, # grpc
  //      9000, # jsonrpc
  //      9100, # node exporter
  //      9113, # nginx exporter - TODO: Needs nginx.conf overview
  //      9115, # blackbox exporter
  //      8080, # cadvisor
  //    ]
  //
  //    content {
  //      from_port = ingress.value
  //      to_port   = ingress.value
  //      protocol  = "tcp"
  //      cidr_blocks = [
  //        "0.0.0.0/0"]
  //    }
  //  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "public_ports" {
  count = var.create_sg && var.create ? length(var.public_ports) : 0

  type              = "ingress"
  security_group_id = join("", aws_security_group.this.*.id)
  protocol          = "tcp"
  from_port         = var.public_ports[count.index]
  to_port           = var.public_ports[count.index]
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "private_ports" {
  count = var.create_sg && var.create ? length(var.private_ports) : 0

  type              = "ingress"
  security_group_id = join("", aws_security_group.this.*.id)
  protocol          = "tcp"
  from_port         = var.private_ports[count.index]
  to_port           = var.private_ports[count.index]
  cidr_blocks       = var.private_port_cidrs
}
