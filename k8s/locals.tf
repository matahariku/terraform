locals {
  ami                  = "ami-04a81a99f5ec58529"
  instance_type        = "t3.medium"
  key_name             = "KEY_BLOC4"
  iam_instance_profile = "LabInstanceProfile"
}

locals {
  tags = {
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}
