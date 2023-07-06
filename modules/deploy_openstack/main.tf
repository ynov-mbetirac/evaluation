resource "null_resource" "connect_ssh" {
    connection {
        type = "ssh"
        user = var.ssh_user
        host = var.ssh_host
        private_key = file(var.ssh_key)
    }
    provisioner "file" {
        source = "authorized_keys"
        destination = "/home/openstack/.ssh/authorized_keys"
    }
    provisioner "file" {
        source = "local.conf"
        destination = "/tmp/"
    }
    provisioner "file" {
        source = "install-stack.sh"
        destination = "/tmp/install-stack.sh"
    }
    provisioner "remote-exec" {
        inline = [
            "echo ${var.password} | sudo -S useradd -s /bin/bash -d /opt/stack -m stack",
            "sudo -S chmod +x /opt/stack",
            "echo 'stack ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/stack",
            "sudo -S apt install git -y",
            "sudo -S chmod +x /tmp/install-stack.sh",
            "cd /tmp",
            "echo ${var.password} | sudo -u stack ./install-stack.sh"
            
        ]
    }
}
