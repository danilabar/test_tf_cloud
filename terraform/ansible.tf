#resource "null_resource" "git" {
#  provisioner "local-exec" {
#    command = "apt install git -y"
#  }
#
#  depends_on = [
#    null_resource.wait
#  ]
#}

resource "null_resource" "pip" {
  provisioner "local-exec" {
    command = "curl https://bootstrap.pypa.io/pip/3.6/get-pip.py -o /tmp/get-pip.py && python3 /tmp/get-pip.py"
  }

  depends_on = [
    #null_resource.git
    null_resource.wait
  ]
}

resource "null_resource" "gitclone" {
  provisioner "local-exec" {
    command = "git clone https://github.com/kubernetes-sigs/kubespray /tmp/kubespray"
  }

  depends_on = [
    null_resource.pip
  ]
}

resource "null_resource" "ansible" {
  provisioner "local-exec" {
#    command = "/usr/local/bin/pip3 install -r /tmp/kubespray/requirements-2.11.txt"
    command = "pip3 install -r /tmp/kubespray/requirements-2.11.txt"
  }

  depends_on = [
    null_resource.gitclone
  ]
}