resource "kubernetes_secret" "jenkins_credentials" {
  metadata {
    name      = "jenkins-credentials"
    namespace = "tools"
  }

  data {
    JENKINS_PASS = "${var.jenkins_password}"
    JENKINS_USER = "${var.jenkins_user}"
  }
}
