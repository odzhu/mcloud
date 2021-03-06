resource "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

resource "helm_release" "nginx-ingress" {
    name = "nginx-ingress"
    repository = "${helm_repository.stable.metadata.0.name}"
    chart     = "stable/nginx-ingress"
    #wait = false
    namespace = "kube-system"
    values = [
      <<-EOF
        rbac:
          create: true
        controller:
          replicaCount: 2
          service:
            annotations: 
              service.beta.kubernetes.io/aws-load-balancer-internal: 0.0.0.0/0
              service.beta.kubernetes.io/aws-load-balancer-backend-protocol: tcp
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