resource "aws_security_group" "allow_all" {
  name        = "tf-any-allow-sg"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.fgtvmvpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-any-allow-sg"
  }
}