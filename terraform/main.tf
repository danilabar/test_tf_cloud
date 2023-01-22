resource "yandex_compute_instance" "public-vm" {
  name     = var.public-vm-name
  hostname = "${var.public-vm-name}.${var.domain}"
  zone     = var.a-zone

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id    = var.centos-7-base
      name        = "root-${var.public-vm-name}"
      type        = "network-nvme"
      size        = "20"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-public.id
    nat       = true
  }

  scheduling_policy {
    preemptible = true  // Прерываемая
  }

  metadata = {
    ssh-keys = "centos:${file("./id_rsa.pub")}"
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
    user-data  = <<-EOF
#!/bin/bash
yum install python3 -y
yum install git -y
curl https://bootstrap.pypa.io/pip/3.6/get-pip.py -o /tmp/get-pip.py
python3 /tmp/get-pip.py
git clone https://github.com/kubernetes-sigs/kubespray /srv/kubespray
/usr/local/bin/pip3 install -r /srv/kubespray/requirements-2.11.txt
EOF
  }

#  provisioner "file" {
#  source      = "../ansible"
#  destination = "/tmp"
#    connection {
#      host = self.network_interface.0.nat_ip_address
#      type     = "ssh"
#      user     = "centos"
#      private_key = "${file("~/.ssh/id_rsa")}"
#    }
#  }

  depends_on = [
    null_resource.ssh_keygen
  ]

}

resource "null_resource" "wait" {
  provisioner "local-exec" {
    #command = "sleep 420"
    command = "sleep 20"
  }

  depends_on = [
    yandex_compute_instance.public-vm
  ]
}