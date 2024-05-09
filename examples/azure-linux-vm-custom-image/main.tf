# Example of how to pass variable for database password:
# terraform apply -var="db_password=..."
# Environment variables can also be used https://www.terraform.io/language/values/variables#environment-variables
# Resource azurerm_linux_virtual_machine requires a preconfigured resource group, virtual network, and subnet in Azure

#Use an Azure Compute Gallery Custom Image
data "azurerm_shared_image" "vmi" {
  name                = "vmi-intel-optimized-aitools-redhat9-azure-spr"
  gallery_name        = "intel_marketplace_compute_galery_eastus"
  resource_group_name = "intel-marketplace-rg"
}


module "azurerm_linux_virtual_machine" {
  #source                              = "../.."
  source                              = "intel/azure-linux-vm/intel"
  azurerm_resource_group_name         = "terraform-testing-rg"
  azurerm_virtual_network_name        = "vm-vnet1"
  virtual_network_resource_group_name = "terraform-testing-rg"
  azurerm_subnet_name                 = "default"
  admin_password                      = var.admin_password
  #Use an Azure Compute Gallery Custom Image
  source_image_id = data.azurerm_shared_image.vmi.id
  tags = {
    "owner"    = "user@company.com"
    "duration" = "1"
  }
}