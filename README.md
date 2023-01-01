# Kubernetes project
This repo houses the files that are being used to build a kubernetes cluster lab. This will be done with multiple tools (most IaC):
* QEMU/KVM - This is the virtualization technology that is being used to build the cluster on top of.
* Packer - For building out the initial VM image. That image will then be used to clone a master node and worker nodes.
* Ansible - Multiple ansible runs. One in the packer provisioner to install the common files that are needed by all nodes in the cluster. Another run after terraform to install the remaining files that are specific to the master and worker nodes. Also, the second ansible run will initialize the cluster, and join the worker nodes to it.
* Terraform - For provisioning out the actual nodes in the cluster. This is done using the base image built by packer. This also creates a variable file for the second ansible run.

The code is written, and confirmed that packer can build the base image.

# TODO
* Confirm that the ansible provisioner in packer will build out the common components for the cluster.
* Test the terraform build process to build out the separate nodes.
* Test the second ansible run to provision the individual nodes.
* Figure out how to automate the terraform and second ansible run so that they don't need to be done manually.