# Example of how to pass variable for database password:
# terraform apply -var="db_password=..."
# Environment variables can also be used https://www.terraform.io/language/values/variables#environment-variables

module "azurerm_linux_virtual_machine" {
  source          = "intel/azure-linux-vm/intel"
  admin_username  = "adminuser"
  admin_password  = var.admin_password
  priority        = "Spot"
  max_bid_price   = 0.0874
  eviction_policy = "Deallocate"

}