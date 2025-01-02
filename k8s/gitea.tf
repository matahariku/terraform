data "cloudinit_config" "gitea" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "gitea-ci.yaml"
    content_type = "text/cloud-config"

    content = file("${path.module}/scripts/gitea-ci.yaml")
  }
}

resource "aws_eip" "gitea" {
  depends_on = [module.vpc]
  instance   = module.gitea.id
  domain     = "vpc"
}

module "gitea" {
  depends_on = [module.vpc]
  source     = "terraform-aws-modules/ec2-instance/aws"

  name = "gitea"

  ami                         = local.ami
  instance_type               = local.instance_type
  key_name                    = local.key_name
  monitoring                  = false
  user_data                   = data.cloudinit_config.gitea.rendered
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.gitea_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
}

module "gitea_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "gitea"
  description = "Security group Gitea service"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 2222
      to_port     = 2222
      protocol    = "tcp"
      description = "SSH Gitea port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH standard port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      description = "Dashboard Gitea port"
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

output "gitea_public_ip" {
  value = module.gitea.public_ip
}

module "gitea-nlb" {
  depends_on = [module.gitea]
  source     = "terraform-aws-modules/alb/aws"

  name                       = "gitea-nlb"
  load_balancer_type         = "network"
  vpc_id                     = module.vpc.vpc_id
  subnets                    = [module.vpc.public_subnets[0]]
  enable_deletion_protection = false

  # Security Group
  enforce_security_group_inbound_rules_on_private_link_traffic = "on"
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  listeners = {
    ex-tcp = {
      port     = 80
      protocol = "TCP"
      forward = {
        target_group_key = "ex-target"
      }
    }
  }

  target_groups = {
    ex-target = {
      name_prefix = "gitea-"
      protocol    = "TCP"
      port        = 3000
      target_type = "ip"
      target_id   = module.gitea.private_ip
    }
  }

}

output "gitea_nlb_dns_name" {
  value = module.gitea-nlb.dns_name
}
