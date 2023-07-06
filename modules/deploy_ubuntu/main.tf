provider "openstack" {
  cloud = "openstack"
}

# Nombre d'instances

variable "instance_count" {
  default = "2"
}

# Noms des instances

variable "instance_name" {
  type = list
  default = ["Web-app", "DB-App"]
}

# Récupération de l'image -- manque de temps pas fonctionnel

#resource "openstack_images_image_v2" "ubuntu" {
#  name             = "ubuntu-img"
#  image_source_url = "http://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
#  container_format = "bare"
#  disk_format      = "qcow2"

#  properties = {
#    key = "value"
#  }
#}

# Création nets & subnets

resource "openstack_networking_network_v2" "network_1" {
  name           = "network_1"
  admin_state_up = "true"
}


resource "openstack_networking_subnet_v2" "ynov-extsub" {
  name       = "ynov-extsub"
  network_id = openstack_networking_network_v2.network_1.id
  cidr       = "172.26.10.0/24"
  ip_version = 4
}

# Création volume

resource "openstack_networking_router_v2" "router_1" {
  name                = "my_router"
  admin_state_up      = true
  external_network_id = "3485a702-df15-497f-8067-6b0661e3fab6"
}

# Création des instances

resource "openstack_compute_instance_v2" "ubuntu22" {
  name = element(var.instance_name, count.index)
  count = var.instance_count
  image_id = "1504ccd5-927e-4cc3-8453-5ee5282d6dd1"
  #image_id = openstack_images_image_v2.ubuntu.id
  flavor_id = "ubuntu"
  key_pair = "ynov-key"
  security_groups = ["default"]

  

  network {
    name = openstack_networking_network_v2.ynov-extsub.id
  }
}
