variable "worker_count" {
  default = 2
}

variable "worker_name" {
  default = "kube-worker-node"
}

variable "master_count" {
  default = 1
}

variable "master_name" {
  default = "kube-master-node"
}

variable "num_cpu" {
  default = 2
}

variable "memory" {
  default = 4096
}

variable "base_image" {
  default = "/data/kvm/build/kube-base.qcow2"
}

variable "data_pool" {
  default = "kvm_images"
}