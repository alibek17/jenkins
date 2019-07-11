resource "kubernetes_namespace" "tools" {
  metadata {
    name = "tools"
  }
}

resource "kubernetes_persistent_volume_claim" "jenkins_pvc" {
  metadata {
    name      = "jenkins-pvc"
    namespace = "tools"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests {
        storage = "10Gi"
      }
    }
  }
}

resource "kubernetes_secret" "jenkins_credentials" {
  metadata {
    name      = "jenkins-credentials"
    namespace = "tools"
  }

  data {
    JENKINS_PASS = "password"
    data         = [119, 112, 95, 117, 115, 101, 114]
    JENKINS_USER = "wp_user"
  }
}

resource "kubernetes_deployment" "jenkins_deployment" {
  metadata {
    name      = "jenkins-deployment"
    namespace = "tools"
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        app = "jenkins"
      }
    }

    template {
      metadata {
        labels {
          app = "jenkins"
        }
      }

      spec {
        volume {
          name = "jenkins-pv"

          persistent_volume_claim {
            claim_name = "jenkins-pvc"
          }
        }

        volume {
          name = "docker-sock"

          host_path {
            path = "/var/run/docker.sock"
          }
        }

        container {
          name  = "jenkins"
          image = "alibek17/jenkins:1.2"

          port {
            container_port = 8080
          }

          env {
            name = "JENKINS_USER"

            value_from {
              secret_key_ref {
                name = "jenkins-credentials"
                key  = "JENKINS_USER"
              }
            }
          }

          env {
            name = "JENKINS_PASS"

            value_from {
              secret_key_ref {
                name = "jenkins-credentials"
                key  = "JENKINS_PASS"
              }
            }
          }

          volume_mount {
            name       = "docker-sock"
            mount_path = "/var/run/docker.sock"
          }

          volume_mount {
            name       = "jenkins-pv"
            mount_path = "/var/jenkins_home"
          }
        }

        security_context {
          run_as_user = 1000
          fs_group    = 1000
        }
      }
    }
  }
}

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

