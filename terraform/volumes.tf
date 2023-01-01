resource "libvirt_volume" "base_volume" {
    name = "kube-base"
    source = var.base_image
}

resource "libvirt_volume" "master_volume" {
    name = "${var.master_name}-${count.index + 1}.qcow2"
    base_volume_id = libvirt_volume.base_volume_id
    count = var.master_count
}

resource "libvirt_volume" "worker_volume" {
    name = "${var.worker_name}-${count.index + 1}.qcow2"
    base_volume_id = libvirt_volume.base_volume_id
    count = var.worker_count
}