resource "null_resource" "install_pip" {
  provisioner "local-exec" {
    command = "curl https://bootstrap.pypa.io/pip/3.6/get-pip.py -o /tmp/get-pip.py && python3 /tmp/get-pip.py"
  }

  depends_on = [
    null_resource.wait
  ]

  triggers = {
      inventory_ip_addresses = yandex_compute_instance.public-vm.network_interface.0.nat_ip_address
  }
}
#---- debug start
resource "null_resource" "install_key" {
  provisioner "local-exec" {
#    command = "echo ${var.ssh_private_key} > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa"
    command = "ssh -o 'StrictHostKeyChecking=no' centos@${yandex_compute_instance.public-vm.network_interface.0.nat_ip_address} whoami"
  }

  depends_on = [
    null_resource.install_pip
  ]

  triggers = {
      inventory_ip_addresses = yandex_compute_instance.public-vm.network_interface.0.nat_ip_address
  }

}

#resource "null_resource" "debug_key" {
#  provisioner "local-exec" {
#    command = "ls -la ~/.ssh/id_rsa && head ~/.ssh/id_rsa"
#  }
#
#  depends_on = [
#    null_resource.install_key
#  ]
#
#  triggers = {
#      inventory_ip_addresses = yandex_compute_instance.public-vm.network_interface.0.nat_ip_address
#  }
#
#}

#---- debug stop

resource "null_resource" "kubespray_checkout" {
  provisioner "local-exec" {
    command = "git clone https://github.com/kubernetes-sigs/kubespray /tmp/kubespray"
  }

  depends_on = [
    null_resource.install_pip
  ]

  triggers = {
      inventory_ip_addresses = yandex_compute_instance.public-vm.network_interface.0.nat_ip_address
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
      inventory_ip_addresses = yandex_compute_instance.public-vm.network_interface.0.nat_ip_address
  }
}

#resource "null_resource" "install_key" {
#  provisioner "local-exec" {
#    command = "echo ${var.ssh_private_key} > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa"
#  }
#
#  depends_on = [
#    null_resource.kubespray_checkout
#  ]
#  triggers = {
#      inventory_ip_addresses = yandex_compute_instance.public-vm.network_interface.0.nat_ip_address
#  }
#}

resource "null_resource" "config_public_vm" {
  provisioner "local-exec" {
#    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory ../ansible/node-preapre.yml --private-key='~/.ssh/id_rsa'"
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory ../ansible/node-preapre.yml"
  }

  depends_on = [
    null_resource.install_requirements
  ]

  triggers = {
      inventory_ip_addresses = yandex_compute_instance.public-vm.network_interface.0.nat_ip_address
  }
}

#resource "null_resource" "ssh_keygen" {
#  provisioner "local-exec" {
#    command = "ssh-keygen -t rsa -f ~/.ssh/id_rsa -C user@terraform -N ''"
#  }
#
#  triggers = {
#      always_run = "${timestamp()}"
#  }
#}
