data "aws_ami" "fgtami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*FortiGate-VMARM64-AWS build*7.6.0*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name  = "architecture"
    values = ["arm64"]
  }

  owners = ["679593333241"]
}

resource "aws_eip" "fgtpublicip" {
  depends_on        = [aws_instance.fgtvm]
  domain            = "vpc"
  network_interface = aws_network_interface.eth0.id
}

resource "aws_network_interface" "eth0" {
  description = "tf-fgtvm-eni1"
  subnet_id   = aws_subnet.publicsubnet.id
}

resource "aws_network_interface" "eth1" {
  description       = "tf-fgtvm-eni2"
  subnet_id         = aws_subnet.privatesubnet.id
  source_dest_check = false
}


resource "aws_network_interface_sg_attachment" "publicattachment" {
  depends_on           = [aws_network_interface.eth0]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.eth0.id
}

resource "aws_network_interface_sg_attachment" "internalattachment" {
  depends_on           = [aws_network_interface.eth1]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.eth1.id
}


resource "aws_instance" "fgtvm" {
  ami               = data.aws_ami.fgtami.id
  instance_type     = var.size
  availability_zone = var.aws_az
  key_name          = aws_key_pair.key_pair.key_name
  user_data = templatefile("fortigate-bootstrap.txt", {
    license_token = "${var.license_token}"
  })

  root_block_device {
    volume_type = "gp2"
    volume_size = "2"
  }

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = "30"
    volume_type = "gp2"
  }

  network_interface {
    network_interface_id = aws_network_interface.eth0.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.eth1.id
    device_index         = 1
  }

  tags = {
    Name = "tf-fgt-vm"
  }
}