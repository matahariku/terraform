module "inter-nodes_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "inter-nodes"
  description = "Security group inter-nodes service"
  vpc_id      = module.vpc.vpc_id

  tags = local.tags

  ingress_with_self = [
    {
      rule = "all-all"
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = -1
      to_port     = -1
      protocol    = "all"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

module "controlplan_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "controlplan"
  description = "Security group controlplan service"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "TCP"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = -1
      to_port     = -1
      protocol    = "all"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

module "worker_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "worker"
  description = "Security group worker service"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "TCP"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = -1
      to_port     = -1
      protocol    = "all"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}
