module "network" {
  source                     = "./VPC"
  vpc_cidr_block             = var.vpc_cidr_block
  public_subnets_cidr_block  = var.public_subnets_cidr_block
  private_subnets_cidr_block = var.private_subnets_cidr_block
  Azs                        = var.Azs
  ingress_ports              = var.ingress_ports
  ingress_cidr_block         = var.ingress_cidr_block
  egress_ports               = var.egress_ports
  egress_cidr_block          = var.egress_cidr_block
}

module "Eks" {
  source            = "./EKS"
  private_subnet_id = module.network.private_subnet_id
  public_subnet_id  = module.network.public_subnet_id
  security_group_id = module.network.security_group_id
  instance_types    = var.Eks_instance_types
}
