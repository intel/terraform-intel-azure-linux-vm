# Example of how to pass variable for database password:
# terraform apply -var="db_password=..."
# Environment variables can also be used https://www.terraform.io/language/values/variables#environment-variables

module "azurerm_linux_virtual_machine" {
  source            = "../../"
  admin_username    = "admin_username"
  admin_password       = var.admin_password
  priority            = var.priority
  max_bid_price       = var.max_bid_price
  eviction_policy     = var.eviction_policy

  # Set the source_image_reference below based on your naming conventions. The value for source_image_reference provided below is for example illustration purposes only
  source_image_reference_offer     = "0001-com-ubuntu-server-lunar"
  source_image_reference_sku       = "23_04-lts-gen2"



}