data "ibm_compute_ssh_key" "deploymentKey" {
  count = var.ssh_key != "" ? 1 : 0
  label = var.ssh_key
}