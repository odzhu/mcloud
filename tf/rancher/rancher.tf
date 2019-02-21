resource "helm_repository" "rancher-latest" {
  name = "rancher-latest"
  url  = "https://releases.rancher.com/server-charts/latest"
}

resource "helm_release" "cert-manager" {
    name = "cert-manager"
    repository = "${helm_repository.stable.metadata.0.name}"
    chart     = "stable/cert-manager"
    wait = false
    force_update = true
    namespace = "kube-system"
    version = "v0.5.2"
}

resource "helm_release" "rancher" {
    name = "rancher"
    repository = "${helm_repository.rancher-latest.metadata.0.name}"
    chart     = "rancher-latest/rancher"
    wait = false
    force_update = true
    namespace = "cattle-system"

    set {
        name = "hostname"
        value = "${data.kubernetes_service.rancher-ingress.load_balancer_ingress.0.hostname}"
    }
    depends_on = ["helm_release.nginx-ingress"]
}
