resource "libvirt_volume" "base_volume" {
    name = "kube-base.qcow2"
    source = var.base_image
    pool = var.data_pool
}

resource "libvirt_volume" "master_volume" {
    name = "${var.master_name}-${count.index + 1}.qcow2"
    base_volume_id = libvirt_volume.base_volume.id
    count = var.master_count
    pool = var.data_pool
}

resource "libvirt_volume" "worker_volume" {
    name = "${var.worker_name}-${count.index + 1}.qcow2"
    base_volume_id = libvirt_volume.base_volume.id
    count = var.worker_count
    pool = var.data_pool
}