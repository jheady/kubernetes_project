resource "libvirt_domain" "master_domain" {
    count = var.master_count
    name = "${var.master_name}=${count.index + 1}"
    memory = var.memory
    vcpu = var.num_cpu
    qemu_agent = true
    disk {
        volume_id = libvirt_volume.master_volume[count.index].id
    }

    # Need to provide serial console
    console {
        type = "pty"
        target_port = "0"
        target_type = "serial"
    }

    console {
        type = "pty"
        target_type = "virtio"
        target_port = "1"
    }

    # Won't get networking without this
    network_interface {
        network_name = "default"
        wait_for_lease = true
    }
}