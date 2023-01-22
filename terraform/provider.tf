provider "yandex" {
 cloud_id  = var.yandex_cloud_id
 folder_id = var.yandex_folder_id
 zone      = var.a-zones[0]
 service_account_key_file = var.service_account_id
}
