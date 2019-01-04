provider "kubernetes" {
        host                   = "${var.host}"
        client_certificate     = "${base64decode(var.client_certificate)}"
        client_key             = "${base64decode(var.client_key)}"
        cluster_ca_certificate = "${base64decode(var.cluster_ca_certificate)}" 
}

provider "helm" {
    kubernetes {
        host                   = "${var.host}"
        client_certificate     = "${base64decode(var.client_certificate)}"
        client_key             = "${base64decode(var.client_key)}"
        cluster_ca_certificate = "${base64decode(var.cluster_ca_certificate)}"
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
    values = [
      <<-EOF
        rbac:
          create: false
        controller:
          replicaCount: 2
          service:
            annotations: {service.beta.kubernetes.io/azure-load-balancer-internal: true}
      EOF
]

}
data "kubernetes_service" "rancher-ingress" {
  metadata {
    name = "${helm_release.nginx-ingress.name}-controller"
    namespace = "${helm_release.nginx-ingress.namespace}"
  }
  depends_on = ["helm_release.nginx-ingress"]
}



