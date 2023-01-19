resource "null_resource" "cluster" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory ../ansible/node-preapre.yml"
  }

  depends_on = [
    null_resource.wait
  ]
}