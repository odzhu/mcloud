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

/*
resource "azurerm_dns_a_record" "rancher" {
  name                = "rancher"
  zone_name           = "${azurerm_dns_zone.admin.name}"
  resource_group_name = "${azurerm_resource_group.admin.name}"
  ttl                 = 300
  records             = ["${data.kubernetes_service.rancher-ingress.load_balancer_ingress.0.ip}"]
}

*/



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