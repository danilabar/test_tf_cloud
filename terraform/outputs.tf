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

output "external_ip_address_k8s_cluster_oo" {
  value = yandex_compute_instance.k8s-cluster[0].network_interface.0.nat_ip_address
}

#output "private_key" {
#  value = tls_private_key.tf_key.private_key_openssh
#  sensitive = true
#}

#output "public_key" {
#  value = tls_private_key.tf_key.public_key_openssh
#}
