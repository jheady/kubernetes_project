packer {
    required_plugins {
        qemu = {
            source = "github.com/hashicorp/qemu"
            version = ">= 1.0.0"
        }
    }
}

variable "system" {
    default = "kube-base"
}

variable "user" {
    default = env("USER")
}

variable "sshcreds" {
    default = "ansible"
}

source "qemu" "kube-base" {
    accelerator = "kvm"
    boot_wait = "5s"
    cd_files = ["./cloudinit/user-data", "./cloudinit/meta-data", "./cloudinit/vendor-data"]
    cd_label = "cidata"
    cpus = "2"
    disk_size = "20G"
    format = "qcow2"
    headless = true
    output_directory = "build"
    memory = "4096"
    ssh_username = var.sshcreds
    ssh_password = var.sshcreds
    ssh_timeout = "30m"
    iso_url = "/home/${var.user}/isoImages/ubuntu-22.04.1-live-server-amd64.iso"
    iso_checksum = "sha256:10f19c5b2b8d6db711582e0e27f5116296c34fe4b313ba45f9b201a5007056cb"
    vm_name = "${var.system}.qcow2"
    boot_command = [
        "e<down><down><down><end>",
        " autoinstall<F10><wait10>"
    ]
    vnc_bind_address = "0.0.0.0" # This allows connecting to VNC from remote hosts in the network
}

build {
    sources = [
        "source.qemu.kube-base"
    ]

    provisioner "ansible" {
        playbook_file = "./kube_base.yml"
        user = var.sshcreds
    }
}
