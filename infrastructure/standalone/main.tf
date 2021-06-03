resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "ibm_compute_ssh_key" "generated_key" {
  label      = "vsrx-ansible-deploy-key"
  notes      = "test_ssh_key_notes"
  public_key = tls_private_key.ssh.public_key_openssh
}

locals {
  hostname           = var.hostname != "" ? var.hostname : "vsrx"
  domain             = var.domain != "" ? var.domain : "example.com"
  vpc_cidr           = var.vpc_cidr != "" ? var.vpc_cidr : null
  pre_shared_key     = var.pre_shared_key != "" ? var.pre_shared_key : null
  vpc_vpn_gateway_ip = var.vpc_vpn_gateway_ip != "" ? var.vpc_vpn_gateway_ip : null
  public_vlan        = var.existing_public_vlan != "" ? data.ibm_network_vlan.public.0.id : ibm_network_vlan.vsrx_public.0.id
  public_vlan_number = var.existing_public_vlan != "" ? data.ibm_network_vlan.public.0.number : ibm_network_vlan.vsrx_public.0.vlan_number
  # public_subnet_gateway = var.existing_public_vlan != "" ? cidrhost(data.ibm_network_vlan.public.0.subnets.0.subnet, 1) / data.ibm_network_vlan.public.0.subnets.0.cidr : cidrhost(ibm_network_vlan.vsrx_public.0.subnets.0.subnet, 1) / ibm_network_vlan.vsrx_public.0.subnets.0.cidr
  private_vlan        = var.existing_private_vlan != "" ? data.ibm_network_vlan.private.0.id : ibm_network_vlan.vsrx_private.0.id
  private_vlan_number = var.existing_private_vlan != "" ? data.ibm_network_vlan.private.0.number : ibm_network_vlan.vsrx_private.0.vlan_number
  #private_subnet_gateway = var.existing_private_vlan != "" ? cidrhost(data.ibm_network_vlan.private[0].subnets[0].subnet, 1) / data.ibm_network_vlan.private[0].subnets[0].cidr : cidrhost(ibm_network_vlan.vsrx_private[0].subnets[0].subnet, 1) / ibm_network_vlan.vsrx_private[0].subnets[0].cidr
  ssh_key_ids = var.ssh_key != "" ? [data.ibm_compute_ssh_key.deploymentKey[0].id, ibm_compute_ssh_key.generated_key.id] : [ibm_compute_ssh_key.generated_key.id]
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
  hostname             = "${local.hostname}-test-instance"
  domain               = var.domain
  os_reference_code    = var.os_image
  datacenter           = var.datacenter
  network_speed        = 1000
  hourly_billing       = true
  private_network_only = false
  local_disk           = true
  flavor_key_name      = var.flavor
  public_vlan_id       = local.public_vlan
  private_vlan_id      = local.private_vlan
  tags                 = ["datacenter:${var.datacenter}"]
  ssh_key_ids          = local.ssh_key_ids
}

resource "ibm_network_gateway" "gateway" {
  name = var.hostname

  members {
    hostname             = local.hostname
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
    notes                = "vSRX standalone deployment"
    ipv6_enabled         = true
    ssh_key_ids          = local.ssh_key_ids
  }
}

module "ansible" {
  depends_on             = [ibm_compute_vm_instance.node]
  source                 = "../../ansible"
  hostname               = local.hostname
  public_subnet          = ibm_compute_vm_instance.node.public_subnet
  public_subnet_gateway  = "169.57.5.65/28"
  public_vlan            = local.public_vlan_number
  private_subnet         = ibm_compute_vm_instance.node.private_subnet
  private_subnet_gateway = "10.130.39.193/26"
  private_vlan           = local.private_vlan_number
  vsrx_public_ip         = ibm_network_gateway.gateway.public_ipv4_address
  vsrx_private_ip        = ibm_network_gateway.gateway.private_ipv4_address
  vpc_cidr               = local.vpc_cidr
  pre_shared_key         = local.pre_shared_key
  vpc_vpn_gateway_ip     = local.vpc_vpn_gateway_ip
}


