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

output "master_IP_addrs" {
  value = libvirt_domain.master_domain.*.network_interface.0.addresses.0
}

output "worker_ip_addrs" {
  value = libvirt_domain.worker_domain.*.network_interface.0.addresses.0
}

# Export terraform variables values to an Ansible var_file
resource "local_file" "tf_ansible_vars_file" {
  content = <<-DOC
    # Ansible vars_file containing variable values from Terraform
    # Generated by Terraform configuration

    tf_master_ips: [${join(",", libvirt_domain.master_domain.*.network_interface.0.addresses.0)}]
    tf_worker_ips: [${join(",", libvirt_domain.worker_domain.*.network_interface.0.addresses.0)}]
    DOC
  filename = "../ansible/tf_ansible_vars_file.yml"
}