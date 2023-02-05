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

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "install_envsubst" {
  provisioner "local-exec" {
    command = "curl -L https://github.com/a8m/envsubst/releases/download/v1.2.0/envsubst-`uname -s`-`uname -m` -o envsubst && chmod +x envsubst"
  }

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

resource "null_resource" "add_supplementary_address" {
  provisioner "local-exec" {
    command = "echo 'supplementary_addresses_in_ssl_keys: [${yandex_compute_instance.k8s-cluster[0].network_interface.0.nat_ip_address}]' >> /tmp/kubespray/inventory/netology-cluster/group_vars/k8s_cluster/k8s-cluster.yml"
  }

  depends_on = [
    null_resource.copy_k8s_cluster_config
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "debug_supplementary_address" {
  provisioner "local-exec" {
    command = "cat /tmp/kubespray/inventory/netology-cluster/group_vars/k8s_cluster/k8s-cluster.yml | grep supplementary_addresses_in_ssl_keys"
  }

  depends_on = [
    null_resource.add_supplementary_address
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
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i /tmp/kubespray/inventory/netology-cluster/inventory /tmp/kubespray/cluster.yml -b -v --flush-cache"
  }

  depends_on = [
    null_resource.install_requirements,
    local_file.private_key,
    null_resource.add_supplementary_address
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

