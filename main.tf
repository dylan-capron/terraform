# main.tf

variable "attacker_ip" {
  default = "192.168.159.167"  # IP de la VM attaquante
}

variable "victim_ip" {
  default = "192.168.159.170"  # IP de la VM victime
}

variable "ssh_user" {
  default = "t"
}

variable "ssh_password" {
  default = "x"
}

variable "ssh_key_path" {
  default = "C:/Users/dylan/.ssh/id_rsa"  # chemin absolu vers ta clé privée SSH
}

resource "null_resource" "provision_attacker" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = var.attacker_ip
      user        = var.ssh_user
      password    = var.ssh_password
      private_key = file(var.ssh_key_path)
      port        = 22
    }
    inline = [
      "sudo apt update -y",
      "sudo apt install -y nmap masscan"
    ]
  }
}

resource "null_resource" "provision_victim" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = var.victim_ip
      user        = var.ssh_user
      private_key = file(var.ssh_key_path)
      port        = 22
    }
    inline = [
      "sudo apt update -y",
      "sudo apt install -y python3",
      "nohup python3 -m http.server 8080 &"
    ]
  }
}
