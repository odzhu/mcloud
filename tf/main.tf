module "admin" {
  source  = "./admin"
}

/*
module "k8s_init" {
  source  = "./k8s_init"
  host = "${module.aks.host}"
  client_certificate = "${module.aks.client_certificate}"
  client_key = "${module.aks.client_key}"
  cluster_ca_certificate = "${module.aks.cluster_ca_certificate}"
}
*/