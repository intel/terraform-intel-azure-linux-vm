output "size" {
  description = "The SKU for the virtual machine"
  value       = azurerm_linux_virtual_machine.linux_vm.size
}
output "location" {
  description = "Location where the virtual machine will be created"
  value       = azurerm_linux_virtual_machine.linux_vm.location
}

output "name" {
  description = "Virtual machine name"
  value       = azurerm_linux_virtual_machine.linux_vm.name
}

output "admin_username" {
  description = "Virtual machine admin username"
  value       = azurerm_linux_virtual_machine.linux_vm.admin_username
}

output "network_interface_ids" {
  description = "List of network interface IDs that are attached to the virtual machine"
  value       = azurerm_linux_virtual_machine.linux_vm.network_interface_ids
}

output "os_disk" {
  description = "Disk properties that are attached to the virtual machine"
  value       = azurerm_linux_virtual_machine.linux_vm.os_disk
}

output "tags" {
  description = "Tags that are assigned to the virtual machine"
  value       = azurerm_linux_virtual_machine.linux_vm.tags
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_linux_virtual_machine.linux_vm.resource_group_name
}

output "virtual_machine_id" {
  description = "ID assigned to the virtual machine after it has been created"
  value       = azurerm_linux_virtual_machine.linux_vm.id
}

output "identity" {
  description = "Identity configuration associated with the virtual machine"
  value       = azurerm_linux_virtual_machine.linux_vm.identity
}

output "storage_account_tier" {
  description = "Tier to identify the storage account associated with the virtual machine"
  value       = try(data.azurerm_storage_account.example[0].account_tier, "")
}