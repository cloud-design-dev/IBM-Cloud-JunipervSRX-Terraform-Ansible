resource "local_file" "ansible-inventory" {
  content = templatefile("${path.module}/ansible/templates/inventory.tmpl",
    {
      vsrx_public_ip = var.vsrx_public_ip
    }
  )
  filename = "${path.module}/ansible/inventory.ini"
}

resource "local_file" "gateway_vars" {
  content = templatefile("${path.module}/ansible/templates/vars.tmpl",
    {
      public_vlan            = data.ibm_network_vlan.public.number
      private_vlan           = data.ibm_network_vlan.private.number
      private_subnet         = data.ibm_network_vlan.private.subnets[0].subnet
      public_subnet          = data.ibm_network_vlan.public.subnets[0].subnet
      private_subnet_gateway = "${cidrhost(data.ibm_network_vlan.private.subnets[0].subnet, 1)}/${data.ibm_network_vlan.private.subnets[0].cidr}"
      public_subnet_gateway  = "${cidrhost(data.ibm_network_vlan.public.subnets[0].subnet, 1)}/${data.ibm_network_vlan.public.subnets[0].cidr}"
      vpc_cidr               = var.vpc_cidr
      pre_shared_key         = var.pre_shared_key
      vpc_vpn_gateway_ip     = var.vpc_vpn_gateway_ip
      vsrx_public_ip         = var.vsrx_public_ip
      vsrx_private_ip        = var.vsrx_private_ip

    }
  )
  filename = "${path.module}/ansible/playbooks/vars.yml"
}

