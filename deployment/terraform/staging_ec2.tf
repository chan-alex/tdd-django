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
    "${aws_security_group.allow_ssh.id}",
    "${aws_security_group.allow_http.id}",
  ]

  root_block_device {
    delete_on_termination = "True"
  }

  tags = {
    role = "${format("%s-app", var.tag_prefix)}"
    env  = "${format("%s-staging", var.tag_prefix)}"
    Name = "${format("%s-staging-app", var.tag_prefix)}"
  }

  volume_tags = {
    role = "${format("%s-app", var.tag_prefix)}"
    env  = "${format("%s-staging", var.tag_prefix)}"
    Name = "${format("%s-staging-app", var.tag_prefix)}"
  }
}
