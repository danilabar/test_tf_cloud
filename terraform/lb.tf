resource "yandex_lb_target_group" "k8s_lb_tg" {
  name = "${terraform.workspace}-k8s-tg"

  dynamic "target" {
    for_each = [for node in yandex_compute_instance.k8s-cluster : {
      address   = node.network_interface.0.ip_address
      subnet_id = node.network_interface.0.subnet_id
    }]

    content {
      subnet_id = target.value.subnet_id
      address   = target.value.address
    }
  }

  depends_on = [
    yandex_compute_instance.k8s-cluster
  ]

}

resource "yandex_lb_network_load_balancer" "k8s-lb" {
  name = "${terraform.workspace}-k8s-lb"

  listener {
    name        = "grafana-listener"
    port        = 3000
    target_port = 30090
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  listener {
    name        = "jenkins-listener"
    port        = 8080
    target_port = 32000
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  listener {
    name        = "app-listener"
    port        = 80
    target_port = 30880
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.k8s_lb_tg.id

    healthcheck {
      name = "http"
      http_options {
        port = 30090
        path = "/login"
      }
    }
  }
}