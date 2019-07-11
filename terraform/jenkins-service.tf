resource "kubernetes_service" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = "tools"

    labels {
      app = "jenkins"
    }
  }

  spec {
    port {
      protocol    = "TCP"
      port        = 8080
      target_port = "8080"
    }

    selector {
      app = "jenkins"
    }

    type = "NodePort"
  }
}

