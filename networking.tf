#VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${var.prefix}-${var.app_name}-vpc"
  }
}


resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.main.id
  private_ips     = ["172.16.13.97"]
  security_groups = [
    aws_security_group.allow_access.id,
    aws_security_group.master_access.id
  ]
}


output "server_public_ip" {
  value = aws_eip.eip-one.public_ip
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "r" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.r.id
}