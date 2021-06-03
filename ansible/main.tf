resource "local_file" "ansible-inventory" {
  content = templatefile("${path.module}/templates/inventory.tmpl",
    {
      vsrx_public_ip = var.vsrx_public_ip
      hostname = var.hostname 
    }
  )
  filename = "${path.module}/inventory.ini"
}

resource "local_file" "playbook_vars" {
  content = templatefile("${path.module}/templates/vars.tmpl",
    {
      public_vlan            = var.public_vlan
      private_vlan           = var.private_vlan
      private_subnet         = var.private_subnet
      public_subnet          = var.public_subnet
      private_subnet_gateway = var.private_subnet_gateway
      public_subnet_gateway  = var.public_subnet_gateway
    }
  )
  filename = "${path.module}/playbooks/vars.yml"
}