resource "helm_repository" "rancher-stable" {
  name = "rancher-stable"
  url  = "https://releases.rancher.com/server-charts/stable"
}


resource "helm_release" "cert-manager" {
    name = "cert-manager"
    repository = "${helm_repository.stable.metadata.0.name}"
    chart     = "stable/cert-manager"
    wait = false
    force_update = true
    namespace = "kube-system"

    set {
        name = "rbac.create"
        value = "false"
    }

}
