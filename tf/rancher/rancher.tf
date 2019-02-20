resource "helm_repository" "rancher-stable" {
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


/*
resource "helm_release" "rancher" {
    name = "rancher"
    repository = "${helm_repository.rancher-stable.metadata.0.name}"
    chart     = "rancher-stable/rancher"
    wait = false
    force_update = true
    namespace = "cattle-system"

    set {
        name = "hostname"
        #value = "${helm_release.nginx-ingress.name}-controller.${helm_release.nginx-ingress.namespace}.svc.cluster.local"
        value = "${data.kubernetes_service.rancher-ingress.load_balancer_ingress.0.ip}"
    }
    set {
        name = "ingress.tls.source"
        value = "letsEncrypt"
    }

    set {
        name = "letsEncrypt.email"
        value = "test@nonexist"
    }
}

*/