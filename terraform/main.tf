resource "yandex_compute_instance" "public-vm" {
  name     = var.public-vm-name
  hostname = "${var.public-vm-name}.${terraform.workspace}.${var.domain}"
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
    user-data = local_file.meta.content
  }

  depends_on = [
    local_file.meta
  ]

}
