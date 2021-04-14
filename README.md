## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| iaas\_classic\_username | The IBM Cloud Classic Infrastructure Username. | `string` | n/a | yes |
| iaas\_classic\_api\_key | The IBM Cloud Classic Infrastructure API key. | `string` | n/a | yes |
| datacenter | The datacenter where the vSRX Gatewally Appliance is deployed. | `string` | n/a | yes |
| project\_name | Name of the vSRX Gateway Appliance. | `string` | n/a | yes |

| ssh\_keys\ | List of SSH key IDs to inject into the virtual server instance | `list(string)` | n/a | yes |
| tags | List of tags to add on all created resources | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the virtual server instance |
| primary_network_interface_id | ID of the virtual server instances primary network interface  | 
| primary_ip4_address | Primary private IP address of the virtual server instance |