resource "yandex_vpc_network" "network-1" {
  name = "${terraform.workspace}-network"
}

resource "yandex_vpc_subnet" "subnet-public" {
  count          = 3
  name           = "${terraform.workspace}-subnet-${var.a-zones[count.index]}"
  zone           = var.a-zones[count.index]
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = [var.cidr[terraform.workspace][count.index]]
}
