
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

resource "helm_release" "nginx-ingress" {
    name = "nginx-ingress"
    repository = "${helm_repository.stable.metadata.0.name}"
    chart     = "stable/nginx-ingress"
    wait = false
    namespace = "kube-system"
    set {
        name = "controller.replicaCount"
        value = "2"
    }
    set {
        name = "rbac.create"
        value = "false"
    }

}

data "kubernetes_service" "nginx-ingress" {
  metadata {
    name = "${helm_release.nginx-ingress.name}-controller"
    namespace = "${helm_release.nginx-ingress.namespace}"
  }
  
}


resource "null_resource" "nginx-ingress-domain" {
  provisioner "local-exec" {
    command = "IP=${data.kubernetes_service.nginx-ingress.load_balancer_ingress.0.ip} && DNSNAME=${helm_release.nginx-ingress.name} && PUBLICIPID=$(az network public-ip list --query \"[?ipAddress!=null]|[?contains(ipAddress, '$IP')].[id]\" --output tsv) && az network public-ip update --ids $PUBLICIPID --dns-name $DNSNAME"
  }
}


data "azurerm_public_ips" "admin_pips" {
  resource_group_name = "${azurerm_kubernetes_cluster.admin.node_resource_group}"
  attached            = true
}

