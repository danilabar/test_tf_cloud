resource "null_resource" "wait" {
  provisioner "local-exec" {
    command = "sleep 30"
  }

  depends_on = [
    yandex_compute_instance.k8s-cluster
  ]
}

resource "null_resource" "install_pip" {
  provisioner "local-exec" {
    command = "curl https://bootstrap.pypa.io/pip/3.6/get-pip.py -o /tmp/get-pip.py && python3 /tmp/get-pip.py"
  }

#  depends_on = [
#    null_resource.wait
#  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "kubespray_checkout" {
  provisioner "local-exec" {
    command = "git clone https://github.com/kubernetes-sigs/kubespray /tmp/kubespray"
  }

  depends_on = [
    null_resource.install_pip
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "copy_k8s_cluster_config" {
#  provisioner "file" {
#    source      = "../ansible/"
#    destination = "/tmp/kubespray/inventory"
#  }
  provisioner "local-exec" {
    command = "cp -r ../ansible/netology-cluster/ /tmp/kubespray/inventory/ && ls -la /tmp/kubespray/inventory/netology-cluster/"
  }

  depends_on = [
    local_file.inventory,
    null_resource.kubespray_checkout
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "install_requirements" {
  provisioner "local-exec" {
    command = "pip3 install -r /tmp/kubespray/requirements-2.11.txt"
  }

  depends_on = [
    null_resource.kubespray_checkout
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "config_k8s_cluster" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i /tmp/kubespray/inventory/netology-cluster/inventory /tmp/kubespray/cluster.yml -b -v"
  }

  depends_on = [
    null_resource.install_requirements,
    local_file.private_key,
    null_resource.copy_k8s_cluster_config
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

