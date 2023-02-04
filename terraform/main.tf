resource "yandex_compute_instance" "k8s-cluster" {
  count    = 3
  name     = "${terraform.workspace}-k8s-node${count.index + 1}"
  hostname = "${terraform.workspace}-k8s-node${count.index + 1}"
  zone     = var.a-zones[count.index]
  platform_id = "standard-v3"
  resources {
    cores  = 4
    memory = 8
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id    = var.centos-7-base
      type        = "network-nvme"
      size        = "20"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-public[count.index].id
    nat       = true
    ipv6      = false
  }

  scheduling_policy {
    preemptible = true  // Прерываемая
  }

  metadata = {
    user-data = local_file.meta.content
  }

  depends_on = [
    local_file.meta
  ]

}
