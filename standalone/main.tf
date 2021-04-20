locals {
  hostname = var.hostname != "" ? var.hostname : "vsrx"
  domain = var.domain != "" ? var.domain : "example.com"
  ssh_key_ids = var.ssh_key != "" ? [data.ibm_is_ssh_key.sshkeydeploymentKey.id, ibm_is_ssh_key.generated_key.id] : [ibm_is_ssh_key.generated_key.id]
}

resource tls_private_key ssh {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource ibm_compute_ssh_key generated_key {
    label = "vsrx-ansible-deploy-key"
    notes = "test_ssh_key_notes"
    public_key = tls_private_key.ssh.public_key_openssh

}

resource "ibm_network_gateway" "gateway" {
  name = var.hostname

  members {
    hostname             = var.hostname
    domain               = var.domain
    datacenter           = var.datacenter
    network_speed        = 1000
    private_network_only = false
    tcp_monitoring       = false
    package_key_name     = "VIRTUAL_ROUTER_APPLIANCE_1_GPBS"
    process_key_name     = "INTEL_XEON_4210_2_20"
    os_key_name          = "OS_JUNIPER_VSRX_19_4_UP_TO_1GBPS_STANDARD_SRIOV"
    redundant_network    = true
    disk_key_names       = ["HARD_DRIVE_2_00_TB_SATA_2"]
    public_bandwidth     = 5000
    memory               = 64
    tags                 = ["datacenter:${var.datacenter}"]
    notes                = "1G vSRX standalone device"
    ipv6_enabled         = true
    ssh_key_ids          = [data.ibm_compute_ssh_key.deploymentKey.id]
  }
}