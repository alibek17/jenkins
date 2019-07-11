terraform {
  backend "s3" {
    bucket = "acirrustech-iaac"
    key    = "eks/jenkins/infra.state"
    region = "us-east-1"
  }
}
