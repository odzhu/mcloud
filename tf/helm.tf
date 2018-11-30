
provider "helm" {
    kubernetes {
       host                   = "${azurerm_kubernetes_cluster.admin.kube_config.0.host}"
        client_certificate     = "${base64decode(azurerm_kubernetes_cluster.admin.kube_config.0.client_certificate)}"
        client_key             = "${base64decode(azurerm_kubernetes_cluster.admin.kube_config.0.client_key)}"
        cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.admin.kube_config.0.cluster_ca_certificate)}"
    }
    tiller_image = "gcr.io/kubernetes-helm/tiller:v2.11.0"
    install_tiller = true
}

resource "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}


resource "helm_release" "vpn" {
    name = "openvpn"
    repository = "${helm_repository.stable.metadata.0.name}"
    chart     = "stable/openvpn"
    wait = false
}