# Example of how to pass variable for database password:
# terraform apply -var="db_password=..."
# Environment variables can also be used https://www.terraform.io/language/values/variables#environment-variables
# Resource azurerm_linux_virtual_machine requires a preconfigured resource group, virtual network, and subnet in Azure


module "azurerm_linux_virtual_machine" {
  source                         = "intel/azure-linux-vm/intel"
  azurerm_resource_group_name    = "<ENTER_RESOURCE_GROUP_NAME_HERE>"
  azurerm_virtual_network_name   = "<ENTER_VIRTUAL_NETWORK_NAME_HERE>"
  azurerm_network_interface_name = "<ENTER_NETWORK_INTERFACE_NAME_HERE>"
  azurerm_subnet_name            = "<ENTER_SUBNET_NAME_HERE>"
  admin_username                 = "ENTER_ADMIN_USERNAME_HERE>"
  admin_password                 = var.admin_password
  priority                       = "Spot"
  max_bid_price                  = 0.0874
  eviction_policy                = "Deallocate"
  tags = {
    "owner"    = "user@company.com"
    "duration" = "1"
  }
}