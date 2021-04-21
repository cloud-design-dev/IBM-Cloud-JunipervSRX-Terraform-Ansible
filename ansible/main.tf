resource "local_file" "ansible-inventory" {
  content = templatefile("${path.module}/templates/inventory.tmpl",
    {
      vsrx_public_ip = var.vsrx_public_ip
      hostname       = var.hostname
    }
  )
  filename = "${path.module}/inventory"
}

resource "local_file" "ansible_inventory_vars" {
  content = templatefile("${path.module}/templates/deployment_vars.tmpl",
    {
      public_vlan            = var.public_vlan
      private_vlan           = var.private_vlan
      private_subnet         = var.private_subnet
      public_subnet          = var.public_subnet
      private_subnet_gateway = "${cidrhost(var.private_subnet, 1)}/26"
      public_subnet_gateway  = "${cidrhost(var.public_subnet, 1)}/28"
    }
  )
  filename = "${path.module}/playbook_vars/deployment_vars.yml"
}