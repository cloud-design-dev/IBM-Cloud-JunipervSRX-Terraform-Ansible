output "id" {
  value = ibm_network_gateway.gateway.id
}

output "public_ipv4_address" {
  value = ibm_network_gateway.gateway.public_ipv4_address
}

output "private_ipv4_address" {
  value = ibm_network_gateway.gateway.private_ipv4_address
}

output "private_vlan_id" {
  value = ibm_network_gateway.gateway.private_vlan_id
}

output "public_vlan_id" {
  value = ibm_network_gateway.gateway.public_vlan_id
}

output "associated_vlans" {
  value = ibm_network_gateway.gateway.associated_vlans
}