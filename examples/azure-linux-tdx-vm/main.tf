# Example of how to pass variable for database password:
# terraform apply -var="db_password=..."
# Environment variables can also be used https://www.terraform.io/language/values/variables#environment-variables
# Resource azurerm_managed_disk requires a preconfigured resource group in Azure
# Resource azurerm_linux_virtual_machine requires a preconfigured resource group, virtual network, and subnet in Azure


module "azurerm_linux_virtual_machine" {
  #source                              = "intel/azure-linux-vm/intel"
  source                              = "../../"
  azurerm_resource_group_name         = "DS-TDXTERRAFORM"
  azurerm_virtual_network_name        = "dstdxvnet"
  virtual_network_resource_group_name = "DS-TDXTERRAFORM"
  azurerm_subnet_name                 = "dstdxsubnet"
  admin_password                      = var.admin_password
  virtual_machine_size                = "Standard_DC2es_v5"
  #Set to flag below to use Intel Confidential VM with TDX
  tdx_flag                            = true
  source_image_reference_publisher    = "Canonical"
  source_image_reference_offer        = "0001-com-ubuntu-confidential-vm-jammy"
  source_image_reference_sku          = "22_04-lts-cvm"
  source_image_reference_version      = "latest"
  vm_name                             = "ds-tdx-linuxvm1"
    tags = {
    "owner"    = "dave.shrestha@intel.com"
    "duration" = "1"
  }
}     

