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
        service_account_name = "jenkins-sa"
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
          image = "alibek17/jenkins:1.1"

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

