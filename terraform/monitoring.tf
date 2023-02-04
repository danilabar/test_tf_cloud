resource "null_resource" "deploy_monitoring_setup" {
  provisioner "local-exec" {
    command = "./kubectl apply --server-side -f ../kube-prometheus/manifests/setup/"
  }

  depends_on = [
    null_resource.get_pods
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "wait_monitoring_setup" {
  provisioner "local-exec" {
    command = "./kubectl wait --for condition=Established --all CustomResourceDefinition --namespace=monitoring"
  }

  depends_on = [
    null_resource.deploy_monitoring_setup
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "deploy_monitoring" {
  provisioner "local-exec" {
    command = "./kubectl apply --server-side -f ../kube-prometheus/manifests/"
  }

  depends_on = [
    null_resource.wait_monitoring_setup
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}