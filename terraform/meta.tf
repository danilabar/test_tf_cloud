resource "tls_private_key" "tf_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "meta" {
  content = <<-DOC
#cloud-config
users:
  - name: centos
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDA6+rHsZRqSFJUtKlabtqBVjhLdFj6pxmXAqLpSY6SbjBeoHV/w/Dw8PWrWOdrHq+BwCCX5w7wzGNen6X4uDgLO+ecu2kN75K7WnwzHp1R30Otu6MF7qvDaCq7aU47+wzvozpDlGuqt95hXE9tvo4NICP79ox+i8IiYFVm2ribBr8ZaksQffQloeNhJ9lIdljw0elAokDvqkyhcpGW5xotn7PBJZT6ZZDewHBNBl4qHahb9zCCkdW0VTmtZkdslWm03zExcusV9RlY+jIZ9gqOpcoJ1x8j7A2A+zUxHP+ct8T6xTRrOHnUcTC920p763moOfzsBi8t6gL0kRE0+d897+HBs6EtRhQ7h03oDR4lwrQHCgyGGUYDl+ruS6SuBVD3KuWUOfxbaFzFOLAWXWiWn4MGzEynmr9/99+EZfumpw1YqnnpG5y72PJL1xCLAIF640WbwK2DypwisndEQIoSzjEFa67KDwUGM56rV7aYE17FjflMi974frqCT6M5i8s= root@ubuntuvm
      - "${tls_private_key.tf_key.public_key_openssh}"
DOC
  filename = "./meta.txt"

  depends_on = [
    tls_private_key.tf_key
  ]
}


resource "local_file" "private_key" {
  content = tls_private_key.tf_key.private_key_openssh
  filename = "/tmp/id_rsa_tf"
  file_permission = "600"

  depends_on = [
    tls_private_key.tf_key
  ]
}

#---- debug start
#resource "null_resource" "test_key" {
#  provisioner "local-exec" {
#    command = "ssh -o 'StrictHostKeyChecking=no' -i /tmp/id_rsa_tf centos@${yandex_compute_instance.public-vm.network_interface.0.nat_ip_address} whoami"
#  }
#
#  depends_on = [
#    null_resource.install_pip
#  ]
#
#  triggers = {
#      always_run = "${timestamp()}"
#  }
#
#}
#---- debug stop
