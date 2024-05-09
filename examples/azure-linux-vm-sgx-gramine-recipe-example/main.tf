#This example deploys a SGX-Capable Azure Virtual Machine (DCs_v3 series)

#Cloud-init is a commonly-used startup configuration utility for cloud compute instances to run the ansible playbook
data "cloudinit_config" "ansible" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "cloud_init.yml"
    content_type = "text/cloud-config"
    content = templatefile(
      "cloud_init.yml",
      {}
    )
  }
}

/* You can verify that the Ansible playbook was deployed successfully by checking the logs on the virtual machine:

ssh azureuser@<vm_ip_address>
tail -f /var/log/ansible/ansible.log
If the Ansible playbook was deployed successfully, you will see a message in the logs indicating that the playbook completed successfully. */


module "azurerm_linux_virtual_machine" {
  #source                              = "../.."
  source                              = "intel/azure-linux-vm/intel"
  azurerm_resource_group_name         = "terraform-testing-rg"
  azurerm_virtual_network_name        = "vm-vnet1"
  virtual_network_resource_group_name = "terraform-testing-rg"
  azurerm_subnet_name                 = "default"
  admin_password                      = var.admin_password

  #SGX-Capable Host
  vm_name                               = "sgx-demo-recipe-test"
  virtual_machine_size                  = "Standard_DC8s_v3"
  ip_configuration_public_ip_address_id = "/subscriptions/d4ab7583-eee6-45fe-9487-a7a0b59a389a/resourceGroups/terraform-testing-rg/providers/Microsoft.Network/publicIPAddresses/terraform-testing-public-ip"

  #Calling the SGX-Ansible Recipe avaliable here : //TODO ADD github link
  custom_data = data.cloudinit_config.ansible.rendered
  source_image_reference = {
    "offer"     = "0001-com-ubuntu-server-focal"
    "sku"       = "20_04-lts-gen2"
    "publisher" = "Canonical"
    "version"   = "latest"
  }
  tags = {
    "owner"    = "user@company.com"
    "duration" = "1"
  }
}
