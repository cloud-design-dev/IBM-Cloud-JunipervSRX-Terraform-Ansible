resource "local_file" "ansible-inventory" {
  content = templatefile("${path.module}/inventory.tmpl",
    {
      vsrx_public_ip = var.vsrx_public_ip
    }
  )
  filename = "${path.module}/inventory"
}

resource "local_file" "playbook_vars" {
  content = templatefile("${path.module}/playbook-openvpn.yml.tmpl",
    {
      bastion_ip             = var.bastion_ip
      subnets                = var.subnets
      openvpn_server_network = var.openvpn_server_network
    }
  )
  filename = "${path.module}/playbook-openvpn.yml"
}