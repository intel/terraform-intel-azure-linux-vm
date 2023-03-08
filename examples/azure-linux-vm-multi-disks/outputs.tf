output "size" {
  description = "The SKU for the virtual machine"
  value       = module.azurerm_linux_virtual_machine.size
}
output "location" {
  description = "Location where the virtual machine will be created"
  value       = module.azurerm_linux_virtual_machine.location
}

output "name" {
  description = "Virtual machine name"
  value       = module.azurerm_linux_virtual_machine.name
}

output "admin_username" {
  description = "Virtual machine admin username"
  value       = module.azurerm_linux_virtual_machine.admin_username
}

output "network_interface_ids" {
  description = "List of network interface IDs that are attached to the virtual machine"
  value       = module.azurerm_linux_virtual_machine.network_interface_ids
}

output "os_disk" {
  description = "Disk properties that are attached to the virtual machine"
  value       = module.azurerm_linux_virtual_machine.os_disk
}

output "tags" {
  description = "Tags that are assigned to the virtual machine"
  value       = module.azurerm_linux_virtual_machine.tags
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.azurerm_linux_virtual_machine.resource_group_name
}

output "virtual_machine_id" {
  description = "ID assigned to the virtual machine after it has been created"
  value       = module.azurerm_linux_virtual_machine.virtual_machine_id
}