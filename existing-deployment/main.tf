resource "local_file" "ansible-inventory" {
  content = templatefile("${path.module}/inventory.tmpl",
    {
      vsrx_public_ip = var.vsrx_public_ip
      hostname       = var.hostname
    }
  )
  filename = "${path.module}/inventory.ini"
}

resource "local_file" "existing_gateway_vars" {
  content = templatefile("${path.module}/existing_vars.tmpl",
    {
      public_vlan            = data.ibm_network_vlan.public.number
      private_vlan           = data.ibm_network_vlan.private.number
      private_subnets        = data.ibm_network_vlan.private.subnets
      public_subnets         = data.ibm_network_vlan.public.subnets
      private_subnet_gateway = "${cidrhost(data.ibm_network_vlan.public.subnets[0].subnet, 1)}/${data.ibm_network_vlan.public.subnets[0].cidr}"
      public_subnet_gateway  = "${cidrhost(data.ibm_network_vlan.public.subnets[0].subnet, 1)}/${data.ibm_network_vlan.public.subnets[0].cidr}"
    }
  )
  filename = "${path.module}/existing_vars.yml"
}