# Overview
This guide will show you how to use Terraform and Ansible to deploy and configure a [Juniper vSRX](https://cloud.ibm.com/docs/vsrx?topic=vsrx-about-ibm-cloud-juniper-vsrx) network gateway on the IBM Cloud. This code allows two deployment types:

 - Deploy new VLANs to associate with the vSRX
 - Use existing VLANs to associate with the vSRX

By default the vSRX will be deployed with 1G network interfaces. If you would like to deploy a 10G vSRX see the description for the following variables in `variables.tf`. I have provided the 10G equivalent  for each variable:

 - os_package
 - os_version
 - process_key
 - network_speed

## Deploy all resources

1. Copy `terraform.tfvars.example` to `terraform.tfvars`:
   ```sh
   cp terraform.tfvars.example terraform.tfvars
   ```
1. Edit `terraform.tfvars` to match your environment. If you would like Terraform to create your VLANs leave `existing_public_vlan` and `existing_private_vlan` as empty strings. To use existing VLANs provide the corresponding VLAN names for those variables. 

   | Name | Description | Required |
   | ---- | ----------- | ---|
   | iaas_classic_username | IBM Cloud Classic Username | Y |
   | iaas_classic_api_key | IBM Cloud Classic User API Key | Y |
   | datacenter | The datacenter where the vSRX will be deployed | Y |
   | ssh_key | Name of an existing SSH key to inject in to the vSRX | N |
   | hostname | Hostname for the vSRX Cluster | N | 
   | domain | Domain name for the vSRX Cluster | N | 
   | existing_public_vlan | Existing Public Vlan name to associate with vSRX| N |
   | existing_private_vlan | Existing Private Vlan name to associate with vSRX| N | 
   ```
1. Plan deployment:
   ```sh
   terraform init
   terraform plan -out default.tfplan
   ```
1. Apply deployment:
   ```sh
   terraform apply default.tfplan
   ```

> Note: It is possible that the `package_key_name`, `process_key_name`, or `os_key_name` could change as new versions of the gateway appliance are released. If you receive an error related to any of these options, the error message will tell you the currently available options. Update the code and re-run your plan / apply to pick up the changes. 

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| iaas\_classic\_username | The IBM Cloud Classic Infrastructure Username. | `string` | n/a | yes |
| iaas\_classic\_api\_key | The IBM Cloud Classic Infrastructure API key. | `string` | n/a | yes |
| datacenter | The datacenter where the vSRX Gatewally Appliance is deployed. | `string` | n/a | yes |
| hostname | Name of the vSRX Gateway Appliance. | `string` | n/a | yes |
| network\_speed | description | `string` | `1000` | yes |
| ssh\_key\_ids | List of SSH key IDs to inject into vsrx host | `list(string)` | n/a | no |
| tags | List of tags to add on all created resources | `list(string)` | `[]` | no |
| private\_network\_only | description | `bool` | `false` | no |
| tcp\_monitoring | description | `bool` | `false` | no |
| redundant\_network | description | `bool` | `false` | no |

[Full List of Network Gateway Inputs](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway#argument-reference)

## Outputs
| Name | Description | 
|------|-------------|
| id | The unique identifier of the network gateway |
| public\_ipv4\_address | The public IP address of the network gateway |
| private_ipv4_address | The private IP address ID of the network gateway |
| public\_vlan\_id | The public VLAN ID for the network gateway. |
| private\_vlan\_id | The private VLAN ID of the network gateway. |
| associated\_vlans | A nested block describing the associated VLANs for the member of the network gateway |

[Full List of Network Gateway Outputs](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway#attribute-reference)


## Configure Gateways via Ansible

### Install the Junos Ansible Collection
This [collection](https://galaxy.ansible.com/junipernetworks/junos) provides ansible modules for interacting with Junos. 

```sh 
ansible-galaxy collection install junipernetworks.junos
```
### Run interface configuration playbook

*This playbook will:*
 - Assign associated VLANs and subnet to CUSTOMER-PUBLIC and CUSTOMER-PRIVATE interfaces
 - Create security zone for CUSTOMER-PUBLIC and CUSTOMER-PRIVATE traffic that allows all system services traffic 
 - Add the CUSTOMER-PUBLIC and CUSTOMER-PRIVATE subnets to the vSRX global address book

```sh
ansible-playbook -i ../../ansible/inventory.ini ../../ansible/playbooks/set-interface-ha.yml
```

![](https://dsc.cloud/quickshare/vsrx-ha.png)

### Run security policy playbook

*This playbook will:*
 - Allow all traffic within CUSTOMER_PUBLIC zone
 - Allow ping and SSH from the internet to the public subnet
 - Allow all outbound traffic from CUSTOMER-PUBLIC to the internet

```sh
ansible-playbook -i ../../ansible/inventory.ini ../../ansible/playbooks/set-security.yml
```

#### Overview of security policy
![](https://dsc.cloud/quickshare/security.png)