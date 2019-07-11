resource "kubernetes_cluster_role" "jenkins_cr" {
  metadata {
    name = "jenkins-cr"
  }

  rule {
    verbs      = ["*"]
    api_groups = ["", "apps", "autoscaling", "batch", "extensions", "policy", "rbac.authorization.k8s.io"]
    resources  = ["configmaps", "daemonsets", "deployments", "ingress", "limitranges", "namespaces", "pods", "persistentvolumes", "persistentvolumeclaims", "serviceaccounts", "services"]
  }

  rule {
    verbs             = ["get", "post"]
    non_resource_urls = ["*"]
  }
}

resource "kubernetes_cluster_role_binding" "jenkins_crb" {
  metadata {
    name = "jenkins-crb"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "jenkins-sa"
    namespace = "tools"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "jenkins-cr"
  }
}

resource "kubernetes_service_account" "jenkins_sa" {
  metadata {
    name      = "jenkins-sa"
    namespace = "tools"
  }
}

