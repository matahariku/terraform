module "wknode1" {
  depends_on = [module.vpc]
  source     = "terraform-aws-modules/ec2-instance/aws"

  name = "wknode1"

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

resource "aws_ebs_volume" "osd1" {
  availability_zone = "us-east-1a"
  size              = 30
}

resource "aws_volume_attachment" "osd1_att" {
  device_name = "/dev/xvdb"
  volume_id   = aws_ebs_volume.osd1.id
  instance_id = module.wknode1.id
}

output "wknode1_private_dns" {
  value = module.wknode1.private_dns
}
