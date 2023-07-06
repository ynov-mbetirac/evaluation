variable "instance_count" {
  default = "2"
}

variable "instance_name" {
  type = list
  default = ["Web-app", "DB-App"]
}

resource "openstack_images_image_v2" "ubuntu" {
  name             = "ubuntu"
  image_source_url = "http://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  container_format = "bare"
  disk_format      = "qcow2"

  properties = {
    key = "value"
  }
}

resource "openstack_compute_flavor_v2" "ubuntu" {
  name  = "ubuntu"
  ram   = "1024"
  vcpus = "1"
  disk  = "10"

  extra_specs = {
    "hw:cpu_policy"        = "CPU-POLICY",
    "hw:cpu_thread_policy" = "CPU-THREAD-POLICY"
  }
}

provider "openstack" {
  cloud = "openstack"
}

resource "openstack_networking_network_v2" "network_1" {
  name           = "network_1"
  admin_state_up = "true"
}


resource "openstack_networking_subnet_v2" "ynov-extsub" {
  name       = "ynov-extsub"
  network_id = openstack_networking_network_v2.network_1.id
  cidr       = "192.168.56.0/24"
  ip_version = 4
}

resource "openstack_networking_router_v2" "router_1" {
  name                = "my_router"
  admin_state_up      = true
  external_network_id = openstack_networking_network_v2.network_1.id
}

resource "openstack_compute_instance_v2" "ubuntu22" {
  name = element(var.instance_name, count.index)
  count = var.instance_count
  image_id = openstack_images_image_v2.ubuntu.id
  flavor_id = openstack_compute_flavor_v2.ubuntu.id
  key_pair = "formation-keypair"
  security_groups = ["default"]
  

  network {
    name = openstack_networking_network_v2.network_1.id
  }
}
