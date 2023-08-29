resource "aws_vpc" "vpc_task" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = "true"

  tags = {
    "kubernetes.io/cluster/eks-test" = "shared"
  }

}

/////////////////////////////////////////////////////////

resource "aws_subnet" "public_subnet_task" {
  vpc_id                  = aws_vpc.vpc_task.id
  cidr_block              = var.public_subnets_cidr_block[0]
  availability_zone       = var.Azs[0]
  map_public_ip_on_launch = true

  tags = {
    "kubernetes.io/cluster/eks-test" = "shared"
    "kubernetes.io/role/elb"         = 1
  }
}

/////////////////////////////////////////////////////////

resource "aws_subnet" "private_subnet_task" {
  vpc_id            = aws_vpc.vpc_task.id
  cidr_block        = var.private_subnets_cidr_block[0]
  availability_zone = var.Azs[1]

  tags = {
    "kubernetes.io/cluster/eks-test"  = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

/////////////////////////////////////////////////////////

resource "aws_eip" "ngw_eip" {
  domain = "vpc"

  tags = {
    "Name" = "task"
  }
}

/////////////////////////////////////////////////////////

resource "aws_nat_gateway" "nat_task" {
  allocation_id = aws_eip.ngw_eip.id
  subnet_id     = aws_subnet.public_subnet_task.id

  tags = {
    Name = "gw NAT"
  }

  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

/////////////////////////////////////////////////////////

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_task.id

  tags = {
    Name = "main-gw"
  }
}

/////////////////////////////////////////////////////////

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc_task.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route"
  }
}


resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet_task.id
  route_table_id = aws_route_table.public_route.id
}


/////////////////////////////////////////////////////////

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.vpc_task.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_task.id
  }

  tags = {
    Name = "private-route"
  }
}


resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.private_subnet_task.id
  route_table_id = aws_route_table.private_route.id
}

/* /////////////////////////////////////////////////////////

resource "aws_instance" "public_ec2" {
  ami               = "ami-053b0d53c279acc90"
  key_name          = aws_key_pair.ec2_key.key_name
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  subnet_id         = aws_subnet.public_subnet_task.id
  security_groups   = [aws_security_group.allow_tls.id]
  tags = {
    Name = "public_ec2"
  }
}

/////////////////////////////////////////////////////////

resource "aws_instance" "private_ec2" {
  ami = "ami-053b0d53c279acc90"
  key_name          = aws_key_pair.ec2_key.key_name
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  subnet_id         = aws_subnet.private_subnet_task.id
  security_groups   = [aws_security_group.allow_tls.id]
  tags = {
    Name = "private_ec2"
  }
} */

/////////////////////////////////////////////////////////

resource "aws_security_group" "allow_tls" {
  name        = "test"
  description = "test"
  vpc_id      = aws_vpc.vpc_task.id

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.ingress_cidr_block]
    }
  }

  dynamic "egress" {
    for_each = var.egress_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = [var.egress_cidr_block]
    }
  }
  tags = {
    Name = "test"
  }
}

/* ----------------- create the private key for the bastion -----------------
/* 
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "task"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "bastion_key" {
  content         = tls_private_key.rsa.private_key_pem
  filename        = "task.pem"
  file_permission = "0400"
}  */
