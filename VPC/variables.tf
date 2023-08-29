variable "vpc_cidr_block" {
  type = string
}

variable "public_subnets_cidr_block" {
  type = list(string)
}

variable "private_subnets_cidr_block" {
  type = list(string)
}

variable "Azs" {
  type = list(string)
}

variable "ingress_ports" {
  description = "List of ingress ports"
  type        = list(number)
  default     = []
}

variable "ingress_cidr_block" {
  description = "Ingress CIDR Block"
}

variable "egress_ports" {
  description = "List of egress ports"
  type        = list(number)
  default     = []
}

variable "egress_cidr_block" {
  description = "Egress CIDR Block"
}
