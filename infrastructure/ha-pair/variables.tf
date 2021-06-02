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

variable "os_image" {
  description = "Default operating system image for compute instance."
  type        = string
  default     = "UBUNTU_18_64"
}

variable "flavor" {
  description = "Default instance size."
  type        = string
  default     = "BL2_2X4X100"
}

variable "domain" {
  description = "Domain for compute instance."
  type        = string
  default     = "clouddesigndev.com"
}

variable "datacenter" {
  description = "Datacenter where instance will be deployed."
  type        = string
  default     = ""
}

variable "ssh_key" {
  description = "Classic IaaS ssh key to add to compute instance."
  type        = string
  default     = ""
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