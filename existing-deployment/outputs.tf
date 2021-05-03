output public_subnets {
  value = data.ibm_network_vlan.public.subnets
}

output private_subnets {
  value = data.ibm_network_vlan.private.subnets
}