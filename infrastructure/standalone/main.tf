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
  oneGconfig = {
    package       = "VIRTUAL_ROUTER_APPLIANCE_1_GPBS"
    os_version    = "OS_JUNIPER_VSRX_19_4_UP_TO_1GBPS_STANDARD_SRIOV"
    process_key   = "INTEL_XEON_4210_2_20"
    network_speed = "1000"
  }
  tenGconfig = {
    package       = "VIRTUAL_ROUTER_APPLIANCE_10_GPBS"
    os_version    = "OS_JUNIPER_VSRX_19_4_UP_TO_10GBPS_STANDARD_SRIOV"
    process_key   = "INTEL_INTEL_XEON_5120_2_20"
    network_speed = "10000"
  }
  hostname    = var.hostname != "" ? var.hostname : "vsrx"
  domain      = var.domain != "" ? var.domain : "example.com"
  ssh_key_ids = var.ssh_key != "" ? [data.ibm_compute_ssh_key.deploymentKey[0].id, ibm_compute_ssh_key.generated_key.id] : [ibm_compute_ssh_key.generated_key.id]
}

resource "ibm_network_vlan" "vsrx_public" {
  name       = "${var.hostname}-public"
  datacenter = var.datacenter
  type       = "PUBLIC"
  tags       = ["datacenter:${var.datacenter}"]
}

resource "ibm_network_vlan" "vsrx_private" {
  name            = "${var.hostname}-private"
  datacenter      = var.datacenter
  type            = "PRIVATE"
  router_hostname = replace(ibm_network_vlan.vsrx_public.router_hostname, "/^f/", "b")
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
    hostname             = var.hostname
    domain               = var.domain
    datacenter           = var.datacenter
    network_speed        = local.oneGconfig.network_speed
    private_network_only = false
    tcp_monitoring       = false
    package_key_name     = local.oneGconfig.package
    process_key_name     = local.oneGconfig.process_key
    os_key_name          = local.oneGconfig.os_version
    redundant_network    = true
    disk_key_names       = ["HARD_DRIVE_2_00_TB_SATA_2"]
    public_bandwidth     = 5000
    memory               = 64
    public_vlan_id       = ibm_network_vlan.vsrx_public.id
    private_vlan_id      = ibm_network_vlan.vsrx_private.id
    tags                 = ["datacenter:${var.datacenter}"]
    notes                = "vSRX standalone deployment"
    ipv6_enabled         = true
    ssh_key_ids          = local.ssh_key_ids
  }
}

module "ansible" {
  depends_on     = [ibm_compute_vm_instance.node]
  source         = "../ansible"
  hostname       = var.hostname
  private_subnet = ibm_compute_vm_instance.node.private_subnet
  public_subnet  = ibm_compute_vm_instance.node.public_subnet
  public_vlan    = ibm_network_vlan.vsrx_public.vlan_number
  private_vlan   = ibm_network_vlan.vsrx_private.vlan_number
  vsrx_public_ip = ibm_network_gateway.gateway.public_ipv4_address
}
