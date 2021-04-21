# Overview
This Repository code for for using Terraform and Ansible to deploy and configure a [Juniper vSRX]() network gateway on the IBM Cloud. 

## Terraform
 - [Standalone 1G/10G vSRX](standalone/) : This deploys a single vSRX instances with 1G or 10G network interfaces.
 - [HA-Pair 1G/10G vSRX](ha-pair/) : This deploys 2 vSRX instances with 1G or 10G interfaces and sets them up in an HA Pair.

## Ansible
 - `set-interfaces.yml` : This will create the networking interfaces within the vSRX for the associated VLANs/subnets.
 - `set-security.yml` : This will create the policies to control the network traffic flow. [Security-flow outlined here](https://cloud.ibm.com/docs/vsrx?topic=vsrx-creating-your-new-traffic-flows)
 - `set-syslog.yml` : Configure vSRX to send control and data plane logs to a syslog server