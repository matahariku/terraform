data "cloudinit_config" "controlplan" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "controlplan-ci.sh"
    content_type = "text/x-shellscript"

    content = file("${path.module}/scripts/controlplan-ci.yaml")
  }
}

data "aws_eip" "controlplan" {
  filter {
    name   = "allocation-id"
    values = ["eipalloc-b1416146-bb57-410a-994f-2656a786cb98"]
  }
}

resource "aws_eip_association" "controlplan_association" {
  allocation_id = data.aws_eip.controlplan.id
  instance_id   = module.cpnode1.id
}

module "cpnode1" {
  depends_on = [
    module.vpc
  ]
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "cpnode1"

  ami                         = local.ami
  instance_type               = local.instance_type
  key_name                    = local.key_name
  monitoring                  = false
  user_data                   = data.cloudinit_config.controlplan.rendered
  associate_public_ip_address = false 
  vpc_security_group_ids = [
    module.controlplan_sg.security_group_id,
    module.inter-nodes_sg.security_group_id
  ]
  subnet_id            = module.vpc.public_subnets[0]
  iam_instance_profile = local.iam_instance_profile
  tags                 = local.tags
}

output "cpnode1_public_ip" {
  value       = data.aws_eip.controlplan.public_ip
  description = "Public IP address for the control plane instance."
}

output "cpnode1_private_dns" {
  value       = module.cpnode1.private_dns
  description = "Private DNS for the control plane instance."
}
