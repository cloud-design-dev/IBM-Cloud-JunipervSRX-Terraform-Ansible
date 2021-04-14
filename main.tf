resource "ibm_network_vlan" "vsrx_public" {
  name       = "${var.project_name}-public"
  datacenter = var.datacenter
  type       = "PUBLIC"
  tags       = ["owner:ryantiffany", "datacenter:${var.datacenter}"]
}

resource "ibm_network_vlan" "vsrx_private" {
  name            = "${var.project_name}-private"
  datacenter      = var.datacenter
  type            = "PRIVATE"
  router_hostname = replace(ibm_network_vlan.vsrx_public.router_hostname, "/^f/", "b")
  tags            = ["owner:ryantiffany", "datacenter:${var.datacenter}"]
}

resource "ibm_network_gateway" "vsrxlab" {
  name = var.project_name

  members {
    hostname             = "${var.project_name}-gw1"
    domain               = var.domain
    datacenter           = var.datacenter
    network_speed        = 10000
    private_network_only = false
    tcp_monitoring       = true
    package_key_name     = "VIRTUAL_ROUTER_APPLIANCE_10_GPBS"
    process_key_name     = "INTEL_INTEL_XEON_5120_2_20"
    os_key_name          = "OS_JUNIPER_VSRX_15_X_UP_TO_10GBPS_STANDARD_SRIOV"
    redundant_network    = true
    disk_key_names       = ["HARD_DRIVE_2_00_TB_SATA_2"]
    public_bandwidth     = 20000
    memory               = 64
    public_vlan_id       = ibm_network_vlan.vsrx_public.id
    private_vlan_id      = ibm_network_vlan.vsrx_private.id
    tags                 = ["owner:ryantiffany", "datacenter:${var.datacenter}"]
    notes                = "vSRX testing boxes for Ansible automation"
    ipv6_enabled         = true
    ssh_key_ids          = [data.ibm_compute_ssh_key.deploymentKey.id]
  }
  members {
    hostname             = "${var.project_name}-gw2"
    domain               = var.domain
    datacenter           = var.datacenter
    network_speed        = 10000
    private_network_only = false
    tcp_monitoring       = true
    package_key_name     = "VIRTUAL_ROUTER_APPLIANCE_10_GPBS"
    process_key_name     = "INTEL_INTEL_XEON_5120_2_20"
    os_key_name          = "OS_JUNIPER_VSRX_15_X_UP_TO_10GBPS_STANDARD_SRIOV"
    redundant_network    = true
    disk_key_names       = ["HARD_DRIVE_2_00_TB_SATA_2"]
    public_bandwidth     = 20000
    memory               = 64
    public_vlan_id       = ibm_network_vlan.vsrx_public.id
    private_vlan_id      = ibm_network_vlan.vsrx_private.id
    tags                 = ["owner:ryantiffany", "datacenter:${var.datacenter}"]
    notes                = "vSRX testing boxes for Ansible automation"
    ipv6_enabled         = true
    ssh_key_ids          = [data.ibm_compute_ssh_key.deploymentKey.id]
  }
}

