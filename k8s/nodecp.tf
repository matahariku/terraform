data "cloudinit_config" "controlplan" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "controlplan-ci.sh"
    content_type = "text/x-shellscript"

    content = file("${path.module}/scripts/controlplan-ci.yaml")
  }
}

resource "aws_eip_association" "controlplan" {
  allocation_id = "eipalloc-06472b648432f45d4" 
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
  value = "54.205.39.197" 
}

output "cpnode1_private_dns" {
  value = module.cpnode1.private_dns
}
