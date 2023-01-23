resource "null_resource" "prepare_copy_kube_config" {
  provisioner "remote-exec" {
    inline = [
#      "sudo cp /root/.kube/config ~/.kube_config && sudo chown $USER:$USER ~/.kube_config"
      "sudo cp /root/original-ks.cfg ~/original-ks.cfg && sudo chown $USER:$USER ~/original-ks.cfg"
    ]
  }

  connection {
    type        = "ssh"
    user        = "centos"
    private_key = tls_private_key.tf_key.private_key_openssh
    host        = yandex_compute_instance.k8s-cluster[0].network_interface.0.nat_ip_address
  }

  depends_on = [
    null_resource.wait
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "mkdir_kube_config" {
  provisioner "local-exec" {
    command = "mkdir ~/.kube"
  }

  depends_on = [
    null_resource.wait
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "copy_kube_config" {
  provisioner "local-exec" {
#    command = "scp -i /tmp/id_rsa_tf -o 'StrictHostKeyChecking no' centos@${yandex_compute_instance.k8s-cluster[0].network_interface.0.nat_ip_address}:/home/centos/.kube_config $HOME/.kube/config"
    command = "scp -i /tmp/id_rsa_tf -o 'StrictHostKeyChecking no' centos@${yandex_compute_instance.k8s-cluster[0].network_interface.0.nat_ip_address}:/home/centos/original-ks.cfg $HOME/.kube/config"
  }

  depends_on = [
    null_resource.mkdir_kube_config
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}

resource "null_resource" "debug_copy_kube_config" {
  provisioner "local-exec" {
    command = "cat $HOME/.kube/config"
  }

  depends_on = [
    null_resource.copy_kube_config
  ]

  triggers = {
      always_run = "${timestamp()}"
  }
}