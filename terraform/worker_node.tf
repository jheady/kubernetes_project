resource "libvirt_domain" "worker_domain" {
    count = var.worker_count
    name = "${var.worker_name}-${count.index + 1}"
    memory = var.memory
    vcpu = var.num_cpu
    qemu_agent = true
    disk {
        volume_id = libvirt_volume.worker_volume[count.index].id
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