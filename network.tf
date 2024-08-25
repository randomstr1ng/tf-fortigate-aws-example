resource "aws_vpc" "fgtvmvpc" {
  cidr_block           = var.vpccidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = "tf-fgtvm-vpc"
  }
}

resource "aws_subnet" "publicsubnet" {
  vpc_id            = aws_vpc.fgtvmvpc.id
  cidr_block        = var.publiccidr
  availability_zone = var.aws_az
  tags = {
    Name = "tf-fgtvm-public-subnet"
  }
}

resource "aws_subnet" "privatesubnet" {
  vpc_id            = aws_vpc.fgtvmvpc.id
  cidr_block        = var.privatecidr
  availability_zone = var.aws_az
  tags = {
    Name = "tf-fgtvm-private-subnet"
  }
}

resource "aws_internet_gateway" "fgtvmigw" {
  vpc_id = aws_vpc.fgtvmvpc.id
  tags = {
    Name = "tf-fgtvm-igw"
  }
}