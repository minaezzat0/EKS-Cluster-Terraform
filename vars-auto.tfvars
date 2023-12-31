vpc_cidr_block             = "10.0.0.0/16"
public_subnets_cidr_block  = ["10.0.1.0/24"]
private_subnets_cidr_block = ["10.0.2.0/24"]
Azs                        = ["us-east-1a", "us-east-1b"]
ingress_ports              = [22]
ingress_cidr_block         = "0.0.0.0/0"
egress_ports               = [0]
egress_cidr_block          = "0.0.0.0/0"
Eks_instance_types         = ["t3.micro"]
