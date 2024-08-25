variable "aws_profile" {
  default = "default"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_az" {
  default = "us-east-1a"
}

variable "vpccidr" {
    default = "10.99.99.0/24"
}

variable "publiccidr" {
    default = "10.99.99.0/25"
}

variable "privatecidr" {
  default = "10.99.99.128/25"
}

variable "size" {
  default = "c6g.large"
}

variable "license_token" {
  type = string
}