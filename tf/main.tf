module "admin" {
  source  = "./admin"
}


module "k8s_init" {
  source  = "./k8s_init"
}