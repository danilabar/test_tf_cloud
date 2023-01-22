output "internal_ip_address_public_vm" {
  value = yandex_compute_instance.public-vm.network_interface.0.ip_address
}

output "external_ip_address_public_vm" {
  value = yandex_compute_instance.public-vm.network_interface.0.nat_ip_address
}

#output "private_key" {
#  value = tls_private_key.tf_key.private_key_openssh
#  sensitive = true
#}

output "public_key" {
  value = tls_private_key.tf_key.public_key_openssh
}
