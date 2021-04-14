## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| iaas\_classic\_username | The IBM Cloud Classic Infrastructure Username. | `string` | n/a | yes |
| iaas\_classic\_api\_key | The IBM Cloud Classic Infrastructure API key. | `string` | n/a | yes |
| datacenter | The datacenter where the vSRX Gatewally Appliance is deployed. | `string` | n/a | yes |
| project\_name | Name of the vSRX Gateway Appliance. | `string` | n/a | yes |
| ssh\_keys\ | List of SSH key IDs to inject into vsrx host | `list(string)` | n/a | yes |
| tags | List of tags to add on all created resources | `list(string)` | `[]` | no |

## Outputs
