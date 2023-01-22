variable "yandex_cloud_id" {
  default = "b1g62d8ululsummdnj71"
}

variable "yandex_folder_id" {
  default = "b1goaocmukt0m7s34gke"
}

variable "a-zones" {
  type    = list(string)
  default = ["ru-central1-a", "ru-central1-b", "ru-central1-c"]
}

variable "cidr" {
  type    = map(list(string))
  default = {
    stage = ["192.168.10.0/24", "192.168.20.0/24", "192.168.30.0/24"]
    prod  = ["192.168.110.0/24", "192.168.120.0/24", "192.168.130.0/24"]
  }
}

variable "centos-7-base" {
  default = "fd8jvcoeij6u9se84dt5"
}

variable "service_account_id" {
  default = ""
  description = "В tf cloud надо сделать sensetive переменную tf service_account_id, без HCL и EOF, т.е. поместить json как есть 'yc iam key create --service-account-name default-sa --output key.json --folder-id <ID_каталога>'"
}
