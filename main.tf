variable "ssh_user" {}
variable "ssh_host" {}
variable "ssh_key" {}
variable "password" {}

#module "deploy_openstack" {
#    source = "./modules/deploy_openstack"
#    ssh_host = var.ssh_host
#    ssh_user = var.ssh_user
#    ssh_key = var.ssh_key
#    password = var.password
#}

module "deploy_ubuntu" {
    source = "./modules/deploy_ubuntu"

}
