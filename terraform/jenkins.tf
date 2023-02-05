resource "null_resource" "deploy_jenkins_ns" {
  provisioner "local-exec" {
    command = "./kubectl apply -f ../jenkins/kube-deploy/namespace.yaml"
  }

  depends_on = [
    null_resource.deploy_monitoring
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "deploy_jenkins" {
  provisioner "local-exec" {
    command = "./kubectl apply -f ../jenkins/kube-deploy/service.yaml -f ../jenkins/kube-deploy/serviceAccount.yaml"
  }

  provisioner "local-exec" {
    command = "./envsubst < ../jenkins/kube-deploy/deployment.yaml | ./kubectl apply -f -"
  }

  depends_on = [
    null_resource.deploy_jenkins_ns
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "wait_k8s_resources" {
  provisioner "local-exec" {
    command = "sleep 90"
  }

  depends_on = [
    null_resource.deploy_jenkins
  ]

  triggers = {
      always_run = "${timestamp()}"
  }

}

resource "null_resource" "get_k8s_resources" {
  provisioner "local-exec" {
    command = "./kubectl get pods,svc --all-namespaces"
  }

  depends_on = [
    null_resource.wait_k8s_resources
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}