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

variable "public_vlan_name" {
  description = "Name of the Public VLAN that will be associated with the Gateway Appliance."
  type        = string
  default     = ""
}

variable "private_vlan_name" {
  description = "Name of the Private VLAN that will be associated with the Gateway Appliance."
  type        = string
  default     = ""
}

variable "hostname" {
  description = "Hostname for vsrx node."
  type        = string
  default     = ""
}

variable "vsrx_public_ip" {
  default = ""
}