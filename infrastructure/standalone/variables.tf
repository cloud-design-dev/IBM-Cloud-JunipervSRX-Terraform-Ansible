variable "iaas_classic_username" {
  description = "IBM Cloud IaaS Username."
  type        = string
  default     = ""
}

variable "iaas_classic_api_key" {
  description = "IBM Cloud IaaS User API key."
  type        = string
  default     = ""
}

variable "ssh_key" {
  description = "SSH Key that will be added to the vSRX. The SSH key is assigned to the root user."
  type        = string
  default     = ""
}

variable "datacenter" {
  description = "Datacenter where instance will be deployed."
  type        = string
  default     = ""
}

variable "domain" {
  description = "Domain for compute instance."
  type        = string
  default     = ""
}

variable "hostname" {
  description = "Hostname for vsrx node."
  type        = string
  default     = ""
}

variable "os_image" {
  description = "Default operating system image for compute instance."
  type        = string
  default     = "UBUNTU_18_64"
}

variable "flavor" {
  type        = string
  description = "Default compute instance size."
  default     = "BL2_2X4X100"
}

variable "existing_public_vlan" {
  type        = string
  default     = ""
  description = "(Optional) Name of an existing Public VLAN to associate to the vSRX."
}

variable "existing_private_vlan" {
  type        = string
  default     = ""
  description = "(Optional) Name of an existing Private VLAN to associate to the vSRX."
}

variable "os_package" {
  type        = string
  description = "Default Gateway Appliance Package. For 10G network devices use `VIRTUAL_ROUTER_APPLIANCE_10_GPBS`."
  default     = "VIRTUAL_ROUTER_APPLIANCE_1_GPBS"
}

variable "os_version" {
  type        = string
  description = "Default Gateway Appliance OS Version. For 10G network devices use `OS_JUNIPER_VSRX_19_4_UP_TO_10GBPS_STANDARD_SRIOV`."
  default     = "OS_JUNIPER_VSRX_19_4_UP_TO_1GBPS_STANDARD_SRIOV"
}

variable "process_key" {
  type        = string
  description = "Default Gateway Appliance processor configuration. For 10G network devices use `INTEL_INTEL_XEON_5120_2_20`."
  default     = "INTEL_XEON_4210_2_20"
}

variable "network_speed" {
  type        = string
  description = "Default Gateway Appliance network speed. For 10G network devices use `10000`."
  default     = "1000"
}

variable "vpc_cidr" {
  type        = string
  description = "(Optional) The VPC subnet that you would like to add to the vSRX address book. This is used when creating security policies. Only needed if you will be running the Ipsec playbook."
  default     = ""
}

variable "pre_shared_key" {
  type        = string
  description = "(Optional) The Preshared Key for the Ipsec tunnel. Only needed if you will be running the Ipsec playbook."
  default     = ""
}

variable "vpc_vpn_gateway_ip" {
  type        = string
  description = "(Optional) The VPC VPN Peer address for the Ipsec tunnel. Only needed if you will be running the Ipsec playbook."
  default     = ""
}