data "cloudinit_config" "worker" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "worker-ci.sh"
    content_type = "text/x-shellscript"

    content = file("${path.module}/scripts/worker-ci.yaml")
  }
}
