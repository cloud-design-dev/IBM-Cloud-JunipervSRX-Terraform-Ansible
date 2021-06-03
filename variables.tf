variable "iaas_classic_api_key" {
  type        = string
  description = "Classic Infrastructure (SoftLayer) API Key."
  default     = ""
}

variable "iaas_classic_username" {
  type        = string
  description = "Classic Infrastructure (SoftLayer) Usernmae."
  default     = ""
}

variable "vsrx_public_ip" {
  type        = string
  description = "The Public IP of the vSRX gateway appliance. This is used for the ansible inventory file as well as the VPN playbook."
  default     = ""
}

variable "vsrx_private_ip" {
  type        = string
  description = "The Private IP of the vSRX gateway appliance. This is used in the VPN playbook."
  default     = ""
}

variable "public_vlan" {
  type        = string
  description = "The name of the associated public vlan. Used to create interface units on the vSRX."
  default     = ""
}

variable "public_subnet" {
  type        = string
  description = "The public subnet that will be added to the interface unit on the vSRX."
  default     = ""
}

variable "private_vlan" {
  type        = string
  description = "The number of the associated private vlan. Used to create interface units on the vSRX"
  default     = ""
}

variable "private_subnet" {
  type        = string
  description = "The private subnet that will be added to the interface unit on the vSRX."
  default     = ""
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