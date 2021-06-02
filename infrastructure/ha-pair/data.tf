data "ibm_compute_ssh_key" "deploymentKey" {
  count = var.ssh_key != "" ? 1 : 0
  label = var.ssh_key
}

data "ibm_network_vlan" "private" {
  count = var.existing_private_vlan != "" ? 1 : 0
  name  = var.existing_private_vlan
}

data "ibm_network_vlan" "public" {
  count = var.existing_public_vlan != "" ? 1 : 0
  name  = var.existing_public_vlan
}