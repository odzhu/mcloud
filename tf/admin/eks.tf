module "eks" {
  source                = "terraform-aws-modules/eks/aws"
  cluster_name          = "${var.name}"
  subnets               = "${module.adminvpc.private_subnets}"
  tags                  = {Name = "${var.name}", Environment = "dev"}
  vpc_id                = "${module.adminvpc.vpc_id}"
  manage_aws_auth       = true
  write_kubeconfig      = true
  config_output_path    = "./tmp/"
}


resource "null_resource" "kubectl_config" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.name}"
  }
depends_on = ["module.eks"]
}
