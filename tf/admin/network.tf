module "adminvpc" {
  source = "terraform-aws-modules/vpc/aws"

  cidr = "${var.adminvpc_cidr}"
  enable_dns_hostnames= "true"
  name = "${var.name}"
  azs = "${var.adminvpc_azs}"
  private_subnets = "${var.adminvpc_private_subnets}"
  public_subnets = "${var.adminvpc_public_subnets}"
  single_nat_gateway = true
  enable_nat_gateway = true
  one_nat_gateway_per_az = false

  tags = {
    Environment = "dev"
  }
}