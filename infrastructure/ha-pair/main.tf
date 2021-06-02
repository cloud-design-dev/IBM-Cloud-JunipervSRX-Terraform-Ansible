resource tls_private_key ssh {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource ibm_compute_ssh_key generated_key {
  label      = "vsrx-ansible-deploy-key"
  notes      = "test_ssh_key_notes"
  public_key = tls_private_key.ssh.public_key_openssh
}

locals {
  hostname            = var.hostname != "" ? var.hostname : "vsrx"
  domain              = var.domain != "" ? var.domain : "example.com"
  public_vlan         = var.existing_public_vlan != "" ? data.ibm_network_vlan.public.0.id : ibm_network_vlan.vsrx_public.0.id
  public_vlan_number  = var.existing_public_vlan != "" ? data.ibm_network_vlan.public.0.number : ibm_network_vlan.vsrx_public.0.vlan_number
  private_vlan        = var.existing_private_vlan != "" ? data.ibm_network_vlan.private.0.id : ibm_network_vlan.vsrx_private.0.id
  private_vlan_number = var.existing_private_vlan != "" ? data.ibm_network_vlan.private.0.number : ibm_network_vlan.vsrx_private.0.vlan_number
  ssh_key_ids         = var.ssh_key != "" ? [data.ibm_compute_ssh_key.deploymentKey[0].id, ibm_compute_ssh_key.generated_key.id] : [ibm_compute_ssh_key.generated_key.id]
}

resource "ibm_network_vlan" "vsrx_public" {
  count      = var.existing_public_vlan != "" ? 0 : 1
  name       = "${local.hostname}-public"
  datacenter = var.datacenter
  type       = "PUBLIC"
  tags       = ["datacenter:${var.datacenter}"]
}

resource "ibm_network_vlan" "vsrx_private" {
  count           = var.existing_private_vlan != "" ? 0 : 1
  name            = "${local.hostname}-private"
  datacenter      = var.datacenter
  type            = "PRIVATE"
  router_hostname = replace(ibm_network_vlan.vsrx_public[0].router_hostname, "/^f/", "b")
  tags            = ["datacenter:${var.datacenter}"]
}

resource "ibm_compute_vm_instance" "node" {
  hostname             = "${var.hostname}-test-instance"
  domain               = var.domain
  os_reference_code    = var.os_image
  datacenter           = var.datacenter
  network_speed        = 1000
  hourly_billing       = true
  private_network_only = false
  local_disk           = true
  flavor_key_name      = var.flavor
  public_vlan_id       = ibm_network_vlan.vsrx_public.id
  private_vlan_id      = ibm_network_vlan.vsrx_private.id
  tags                 = ["datacenter:${var.datacenter}"]
  ssh_key_ids          = local.ssh_key_ids
}

resource "ibm_network_gateway" "gateway" {
  name = var.hostname

  members {
    hostname             = "${local.hostname}-gw1"
    domain               = var.domain
    datacenter           = var.datacenter
    network_speed        = var.network_speed
    private_network_only = false
    tcp_monitoring       = false
    package_key_name     = var.os_package
    process_key_name     = var.process_key
    os_key_name          = var.os_version
    redundant_network    = true
    disk_key_names       = ["HARD_DRIVE_2_00_TB_SATA_2"]
    public_bandwidth     = 5000
    memory               = 64
    public_vlan_id       = local.public_vlan
    private_vlan_id      = local.private_vlan
    tags                 = ["datacenter:${var.datacenter}"]
    notes                = "vSRX testing boxes for Ansible automation"
    ipv6_enabled         = true
    ssh_key_ids          = local.ssh_key_ids
  }
  members {
    hostname             = "${local.hostname}-gw2"
    domain               = var.domain
    datacenter           = var.datacenter
    network_speed        = var.network_speed
    private_network_only = false
    tcp_monitoring       = false
    package_key_name     = var.os_package
    process_key_name     = var.process_key
    os_key_name          = var.os_version
    redundant_network    = true
    disk_key_names       = ["HARD_DRIVE_2_00_TB_SATA_2"]
    public_bandwidth     = 20000
    memory               = 64
    tags                 = ["datacenter:${var.datacenter}"]
    notes                = "vSRX testing boxes for Ansible automation"
    ipv6_enabled         = true
    ssh_key_ids          = local.ssh_key_ids
  }
}

module "ansible" {
  depends_on     = [ibm_compute_vm_instance.node]
  source         = "../../ansible"
  hostname       = local.hostname
  private_subnet = ibm_compute_vm_instance.node.private_subnet
  public_subnet  = ibm_compute_vm_instance.node.public_subnet
  public_vlan    = local.public_vlan_number
  private_vlan   = local.private_vlan_number
}
