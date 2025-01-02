module "wknode3" {
  depends_on = [module.vpc]
  source     = "terraform-aws-modules/ec2-instance/aws"

  name = "wknode3"

  ami                         = local.ami
  instance_type               = local.instance_type
  key_name                    = local.key_name
  monitoring                  = false
  user_data                   = data.cloudinit_config.worker.rendered
  associate_public_ip_address = false
  vpc_security_group_ids = [
    module.worker_sg.security_group_id,
    module.inter-nodes_sg.security_group_id
  ]
  subnet_id            = module.vpc.private_subnets[0]
  iam_instance_profile = local.iam_instance_profile
  tags                 = local.tags
}

resource "aws_ebs_volume" "osd3" {
  availability_zone = "us-east-1a"
  size              = 30
}

resource "aws_volume_attachment" "osd3_att" {
  device_name = "/dev/xvdb"
  volume_id   = aws_ebs_volume.osd3.id
  instance_id = module.wknode3.id
}

output "wknode3_private_dns" {
  value = module.wknode3.private_dns
}
