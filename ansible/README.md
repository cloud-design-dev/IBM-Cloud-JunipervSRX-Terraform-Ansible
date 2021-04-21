## Terraform
 - Generates an inventory file for the Network Gateway
 - Generates a variables file for the ansible playbooks

## Ansible
 - `set-interfaces-*.yml` : This will create the networking interfaces within the vSRX for the associated VLANs/subnets. There are unique playbooks for the `standalone` and `ha` deployments.
 - `set-security.yml` : This will create the policies to control the network traffic flow. [Security-flow outlined here](https://cloud.ibm.com/docs/vsrx?topic=vsrx-creating-your-new-traffic-flows)
 - `set-syslog.yml` : Configure vSRX to send control and data plane logs to a syslog server
