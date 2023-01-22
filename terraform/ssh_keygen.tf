resource "null_resource" "ssh_keygen" {
  provisioner "local-exec" {
    command = "ssh-keygen -t rsa -f ~/.ssh/id_rsa -C user@terraform -N ''"
  }

  triggers = {
      always_run = "${timestamp()}"
  }
}




