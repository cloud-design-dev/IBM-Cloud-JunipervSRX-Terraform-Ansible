data "ibm_network_vlan" "public" {
  name = var.public_vlan
  #number  = var.public_vlan
}

data "ibm_network_vlan" "private" {
  name = var.private_vlan
  #number  = var.private_vlan
}
