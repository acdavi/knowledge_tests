provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "khomp" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.khomp.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_instance" "webserver" {
    ami = "ami-08fdec01f5df9998f"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet.id
}

variable "ssh-ip" {
    default = "0.0.0.0/0"
    description = "Unico IP que pode acessar"
    type = string
}

resource "aws_security_group" "ssh-group" {
    name = "Acesso SSH"
    description = "Acesso SSH"
    vpc_id = aws_vpc.khomp.id

    ingress {
        description = "Acesso SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.ssh-ip}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_s3_bucket" "b" {
  bucket = "khomp.bucket"
}
