# Example of how to pass variable for database password:
# terraform apply -var="db_password=..."
# Environment variables can also be used https://www.terraform.io/language/values/variables#environment-variables
# Resource azurerm_managed_disk requires a preconfigured resource group in Azure
# Resource azurerm_linux_virtual_machine requires a preconfigured resource group, virtual network, and subnet in Azure

# Initialize Densify Module that will parse the densify_recommendations.auto.tfvars recommendation file
module "densify" {
  source  = "densify-dev/optimization-as-code/null"
  densify_recommendations = var.densify_recommendations
  densify_fallback        = var.densify_fallback
  densify_unique_id       = var.name
}

resource "azurerm_managed_disk" "managed_disk" {
  name                 = "managed_disk_name"
  resource_group_name  = "ds-terraform-testing-rg"
  storage_account_type = "Standard_LRS"
  location             = "eastus"
  create_option        = "Empty"
  disk_size_gb         = 8
  tags = {
    "owner"    = "user@company.com"
    "duration" = "1"
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.managed_disk.id
  virtual_machine_id = module.azurerm_linux_virtual_machine.virtual_machine_id
  lun                = 10
  caching            = "ReadWrite"
}

module "azurerm_linux_virtual_machine" {
  source                              = "intel/azure-linux-vm/intel"
  azurerm_resource_group_name         = "terraform-testing-rg"
  azurerm_virtual_network_name        = "vnet01"
  virtual_network_resource_group_name = "terraform-testing-rg"
  azurerm_subnet_name                 = "default"
  admin_password                      = var.admin_password

  # ICO by Densify normal way of sizing an instance by hardcoding the size.
  #virtual_machine_size = "Standard_D4ds_v4"

  # ICO by Densify new self-optimizing instance type from Densify
  virtual_machine_size = module.densify.instance_type
      
  tags = {
    "owner"    = "user@company.com"
    "duration" = "1"
    # ICO by Densify tag instance to make it Self-Aware these tags are optional and can set as few or as many as you like.
    Name = var.name
    Current-instance-type = module.densify.current_type
    Densify-optimal-instance-type = module.densify.recommended_type
    Densify-potential-monthly-savings = module.densify.savings_estimate
    Densify-predicted-uptime = module.densify.predicted_uptime
    #Should match the densify_unique_id value as this is how Densify references the system as unique
    Densify-Unique-ID = var.name
  }
}

