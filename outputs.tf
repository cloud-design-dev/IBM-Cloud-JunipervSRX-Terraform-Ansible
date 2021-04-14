output "public_ipv4_address" {
  value = ibm_network_gateway.vsrxlab.public_ipv4_address
}

output "private_vlan_id" {
  value = ibm_network_gateway.vsrxlab.private_vlan_id
}

output "public_vlan_id" {
  value = ibm_network_gateway.vsrxlab.public_vlan_id
}

output "associated_vlans" {
  value = ibm_network_gateway.vsrxlab.associated_vlans
}