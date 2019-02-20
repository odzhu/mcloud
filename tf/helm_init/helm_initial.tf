
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

provider "helm" {
    tiller_image = "gcr.io/kubernetes-helm/tiller:v2.12.3"
    install_tiller = true
    service_account = "tiller"
    namespace = "kube-system"
}

resource "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
  depends_on = ["kubernetes_cluster_role_binding.tiller"]
}

