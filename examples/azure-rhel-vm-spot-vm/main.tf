# Example of how to pass variable for database password:
# terraform apply -var="db_password=..."
# Environment variables can also be used https://www.terraform.io/language/values/variables#environment-variables
# Resource azurerm_linux_virtual_machine requires a preconfigured resource group, virtual network, and subnet in Azure


module "azurerm_linux_virtual_machine" {
  #source                              = "../.."
  source                              = "intel/azure-linux-vm/intel"
  azurerm_resource_group_name         = "ai-opea-chatqna-rg"
  azurerm_virtual_network_name        = "vm-vnet1"
  virtual_network_resource_group_name = "ai-opea-chatqna-rg"
  vm_name                             = "redhat8-vm01"
  os_disk_name                        = "value"
  azurerm_network_interface_name      = "redhat8-nic01"
  azurerm_subnet_name                 = "default"
  admin_password                      = var.admin_password
  source_image_reference = {
    "offer"     = "RHEL"
    "sku"       = "8-LVM-gen2"
    "publisher" = "RedHat"
    "version"   = "latest"
  }
  priority        = "Spot"
  max_bid_price   = 0.0874
  eviction_policy = "Deallocate"
  tags = {
    "owner"    = "user@company.com"
    "duration" = "1"
  }
}