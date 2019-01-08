
provider "helm" {
    tiller_image = "gcr.io/kubernetes-helm/tiller:v2.11.0"
    install_tiller = true
    service_account = "tiller"
    namespace = "kube-system"
}

resource "kubernetes_service_account" "tiller" {
  metadata {
    name = "tiller"
    namespace = "kube-system"
  }
}
resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
        name = "tiller"
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "User"
    name      = "system:serviceaccount:kube-system:tiller"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind  = "ClusterRole"
    name = "cluster-admin"
  }
  depends_on = ["kubernetes_service_account.tiller"]
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
            annotations: 
              service.beta.kubernetes.io/aws-load-balancer-internal: 0.0.0.0/0
              service.beta.kubernetes.io/aws-load-balancer-backend-protocol: tcp
      EOF
]
}

/*
data "kubernetes_service" "rancher-ingress" {
  metadata {
    name = "${helm_release.nginx-ingress.name}-controller"
    namespace = "${helm_release.nginx-ingress.namespace}"
  }
  depends_on = ["helm_release.nginx-ingress"]
}
*/