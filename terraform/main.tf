terraform {
  required_providers {
    # See https://registry.terraform.io/providers/dmacvicar/libvirt
    # See https://github.com/dmacvicar/terraform-proider-libvirt
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.7.0"
    }
  }
}

# Instantiate the provider
provider "libvirt" {
  uri = "qemu:///system"
}

output "master_ip_addrs" {
  value = libvirt_domain.master_domain.*.network_interface.0.addresses.0
}

output "worker_ip_addrs" {
  value = libvirt_domain.worker_domain.*.network_interface.0.addresses.0
}

locals {
  worker_hosts_list = jsonencode([
    for name, ip in libvirt_domain.worker_domain.* : "${replace(name, ("/\\d/"), "kube-worker-node-${name + 1} ansible_ssh_host=${ip.network_interface.0.addresses.0}")}"
  ])
  worker_hosts_list2 = replace("${local.worker_hosts_list}", ",", "\n")
  worker_hosts_list3 = replace("${local.worker_hosts_list2}", "\"", "")
  worker_hosts_list4 = replace("${local.worker_hosts_list3}", "[", "")
  worker_hosts_list5 = replace("${local.worker_hosts_list4}", "]", "")
}

# Generate ansible hosts file
resource "local_file" "tf_hosts_file" {
  content = <<-DOC
    # Ansible hosts file for the cluster buildout
    # Generatd by Terraform configuration

    [master_node]
    kube-master-node-1 ansible_ssh_host=${libvirt_domain.master_domain.0.network_interface.0.addresses.0}
    
    [worker_nodes]
    ${local.worker_hosts_list5}

    DOC
  filename = "../ansible/hosts"
}