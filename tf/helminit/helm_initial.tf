resource "kubernetes_service_account" "tiller" {
  metadata {
    name = "tiller"
    namespace = "kube-system"
  }
  automount_service_account_token = true
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
resource "null_resource" "helminit" {
  provisioner "local-exec" {
    command = "helm init -c && kubectl delete deployments -n kube-system tiller-deploy"
  }
  depends_on = ["kubernetes_cluster_role_binding.tiller"]
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
  depends_on = ["null_resource.helminit"]
  provisioner "local-exec" {
    command = "sleep 8"
  } 
}
resource "helm_release" "vpn" {
    name = "openvpn"
    repository = "${helm_repository.stable.metadata.0.name}"
    chart     = "stable/openvpn"
    wait = false
    depends_on = ["helm_repository.stable"]
}