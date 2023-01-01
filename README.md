# Kubernetes project
This repo houses the files that are being used to build a kubernetes cluster lab. This will be done with multiple tools (most IaC):
* QEMU/KVM - This is the virtualization technology that is being used to build the cluster on top of.
* Packer - For building out the initial VM image. That image will then be used to clone a master node and worker nodes.
* Ansible - Multiple ansible runs. One in the packer provisioner to install the common files that are needed by all nodes in the cluster. Another run after terraform to install the remaining files that are specific to the master and worker nodes. Also, the second ansible run will initialize the cluster, and join the worker nodes to it.
* Terraform - For provisioning out the actual nodes in the cluster. This is done using the base image built by packer. This also creates a variable file for the second ansible run.

The code is written, and confirmed that packer can build the base image. Also confirmed that the ansible provisioner works properly.

# Instructions for use
* Forke or clone the repo
* Download ubuntu 22.04 server ISO and update iso_url and iso_checksum appropriately
* Generate a key for ansible user: `ssh-keygen -C ansible -f cloudinit/ansible`
* Replace public key in user-data file
* Ensure output directory parent exists, or modify `packer_base.pkr.hcl` and `variables.tf` to point to a desired location. Packer build will fail if output directory itself exists, so just make sure it's parent exists.

# TODO
* Test the terraform build process to build out the separate nodes.
* Test the second ansible run to provision the individual nodes.
* Figure out how to automate the terraform and second ansible run so that they don't need to be done manually.
