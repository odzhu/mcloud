module "eks" {
  source                = "terraform-aws-modules/eks/aws"
  cluster_name          = "${var.name}"
  subnets               = "${module.adminvpc.private_subnets}"
  tags                  = {Name = "${var.name}", Environment = "dev"}
  vpc_id                = "${module.adminvpc.vpc_id}"
  manage_aws_auth       = true
  write_kubeconfig      = false
}