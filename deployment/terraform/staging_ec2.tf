resource "aws_eip" "staging" {
  vpc = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_eip_association" "staging" {
  allocation_id        = "${aws_eip.staging.id}"
  network_interface_id = "${aws_instance.staging.primary_network_interface_id}"
}

resource "aws_instance" "staging" {
  ami           = "${var.ami_id}"
  instance_type = "t2.medium"
  key_name      = "${var.key_name}"
  subnet_id     = "${aws_subnet.network.id}"

  vpc_security_group_ids = [
    "${aws_security_group.allow_egress.id}",
    "${aws_security_group.allow_ssh.id}",
    "${aws_security_group.allow_http.id}",
  ]

  user_data = "${file("user_data.sh")}"

  root_block_device {
    delete_on_termination = "True"
  }

  tags = {
    project = "${var.tag_prefix}"
    role    = "app"
    env     = "staging"
    Name    = "${format("%s-staging-app", var.tag_prefix)}"
  }

  volume_tags = {
    project = "${var.tag_prefix}"
    role    = "app"
    env     = "staging"
    Name    = "${format("%s-staging-app", var.tag_prefix)}"
  }
}

resource "aws_route53_record" "staging-app" {
  zone_id = "Z1JNRRWK6ETOJ7"
  name    = "tdd-python-staging.chanalex.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.staging.public_ip}"]
}
