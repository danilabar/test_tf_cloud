output "internal_ip_address_k8s_cluster" {
  value = {
    for node in yandex_compute_instance.k8s-cluster:
        node.hostname => node.network_interface.0.ip_address
  }
}

output "external_ip_address_k8s_cluster" {
  value = {
    for node in yandex_compute_instance.k8s-cluster:
        node.hostname => node.network_interface.0.nat_ip_address
  }
}

output "external_ip_address_control_plane" {
  value = [
    "cp1 => ${yandex_compute_instance.k8s-cluster[0].network_interface.0.nat_ip_address}",
    "cp2 => ${yandex_compute_instance.k8s-cluster[1].network_interface.0.nat_ip_address}"
  ]
}

output "external_load_balancer_ip" {
  value = yandex_lb_network_load_balancer.k8s-lb.listener.*.external_address_spec[0].*.address[0]
}

#output "external_ip_address_k8s_cluster_oo" {
#  value = yandex_compute_instance.k8s-cluster[0].network_interface.0.nat_ip_address
#}

#output "private_key" {
#  value = tls_private_key.tf_key.private_key_openssh
#  sensitive = true
#}

#output "public_key" {
#  value = tls_private_key.tf_key.public_key_openssh
#}
