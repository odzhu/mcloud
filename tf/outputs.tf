output "admin_k8s_cluster_name" {
  value = "${azurerm_kubernetes_cluster.admin.name}"
}