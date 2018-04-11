########## Subnets ############

resource "aws_subnet" "network" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${var.public-cidr}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.AZ}"

  tags = {
    Name = "${format("%s-public", var.tag_prefix)}"
  }
}

########## Route tables ############

resource "aws_route_table" "public_rt" {
  vpc_id = "${var.vpc_id}"

  route = [{
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.igw}"
  }]

  tags = {
    Name = "${format("%s-public-rt", var.tag_prefix)}"
  }
}

resource "aws_route_table_association" "network" {
  subnet_id      = "${aws_subnet.network.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

########## Security groups ##########

data "aws_vpc" "selected_vpc" {
  id = "${var.vpc_id}"
}

resource "aws_security_group" "allow_egress" {
  name        = "${format("%s-allow_egress", var.tag_prefix)}"
  description = "-"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${format("%s-allow_egress", var.tag_prefix)}"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "${format("%s-allow_ssh_external", var.tag_prefix)}"
  description = "-"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_vpc.selected_vpc.cidr_block}"]
  }

  tags = {
    Name = "${format("%s-allow_ssh", var.tag_prefix)}"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "${format("%s-allow_http", var.tag_prefix)}"
  description = "-"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${format("%s-allow_http", var.tag_prefix)}"
  }
}
