# Overview
This Repository code for for using Terraform and Ansible to deploy and configure a [Juniper vSRX](https://cloud.ibm.com/docs/vsrx?topic=vsrx-about-ibm-cloud-juniper-vsrx)  network gateway on the IBM Cloud. 

## Prerequisites
 - [terraform](https://www.terraform.io/downloads.html) installed.
 - [ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) installed.
 - An [IBM Cloud Infrastructure Username and API Key](https://cloud.ibm.com/docs/account?topic=account-classic_keys).

## Deploy all resources
1. Clone repository:
    ```sh
    git clone https://github.com/cloud-design-dev/IBM-Cloud-JunipervSRX-Terraform-Ansible.git
    cd IBM-Cloud-JunipervSRX-Terraform-Ansible
    ```
1. Copy `terraform.tfvars.template` to `terraform.tfvars`:
   ```sh
   cp terraform.tfvars.template terraform.tfvars
   ```
1. Edit `terraform.tfvars` to match your environment.
1. Deploy all resources:
   ```sh
   terraform init
   terraform plan -out default.tfplan 
   terraform apply default.tfplan
   ```

After the plan completes we will move on to configuring the gateway using Ansible. 

## Run Ansible playbook to create the Public and Private interfaces
For a standalone gateway appliance use the `set-interface-standalone.yml` playbook. For an HA pair use the `set-interface-ha.yml` playbook. This will create the networking interfaces within the vSRX for the associated VLANs/subnets.


```sh
ansible-playbook -i ansible/inventory ansible/playbooks/set-interface-[standalone/ha].yml
```
## Run Ansible playbook to zone security policies
This will create the policies to control the network traffic flow. For this playbook I am using the Security-flow that is outlined [here](https://cloud.ibm.com/docs/vsrx?topic=vsrx-creating-your-new-traffic-flows).

```sh
ansible-playbook -i ansible/inventory ansible/playbooks/set-security.yml
```

## Run Ansible playbook to configure a Syslog server
This will configure the vSRX to send Syslogs to a remote server. You will need to update the playbook and substitute `SYSLOG_IP` with the IP of your syslog server.

1. Edit `ansible/playbooks/set-logging.yml` and replace `SYSLOG_IP` with the IP of your syslog server.
1. Run playbook
```sh
ansible-playbook -i ansible/inventory ansible/playbooks/set-logging.yml
```

## Run Ansible playbook to configure an IPsec tunnel to a VPC VPN Gateway server
This will create an IPsec tunnel on the vSRX with a remote Peer in IBM Cloud VPC. It will create the tunnel interface and appropriate IPsec/IKE/security policies.

**Note**: IBM Cloud VPN VPN requires a custom IPsec policy as outlined [here](). Please make sure the VPN connection you create uses this custom IPsec policy. 

```sh
ansible-playbook -i ansible/inventory ansible/playbooks/set-logging.yml
```

After the playbook completes you can log in to the vSRX and check the status of the tunnel:

*Configuration Mode*
```sh
run show security ipsec security-associations 
```