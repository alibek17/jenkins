resource "kubernetes_namespace" "tools" {
  metadata {
    name = "tools"
  }
}

