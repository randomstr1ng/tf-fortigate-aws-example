data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name  = "architecture"
    values = ["x86_64"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "webserver" {
  depends_on             = [aws_instance.fgtvm]
  instance_type          = "t3.small"
  ami                    = data.aws_ami.ubuntu.id
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  subnet_id              = aws_subnet.appesubnet1.id
  user_data              = base64encode(templatefile("webserver-bootstrap.txt", {}))

  tags = {
    Name = "tf-webserver-vm"
  }

  root_block_device {
    volume_size = 20
  }
}