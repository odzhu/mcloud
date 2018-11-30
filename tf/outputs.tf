output "admin_k8s_cluster_name" {
  value = "${azurerm_kubernetes_cluster.admin.name}"
}

output "vpn_output" {
  value = "${helm_release.vpn.metadata}"
}
output "admin_kubernetes_ingress_public_ip" {
  value = "${data.kubernetes_service.nginx-ingress.load_balancer_ingress.0.ip}"
}

output "admin_kubernetes_ingress_public_hostname" {
  value = "${data.azurerm_public_ips.admin_pips.public_ips}"
}