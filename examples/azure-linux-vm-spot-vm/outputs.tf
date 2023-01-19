output "size" {
  value = azurerm_linux_virtual_machine.example.virtual_machine_size
}
output "location" {
  value = azurerm_linux_virtual_machine.example.location
}

output "name" {
  value = azurerm_linux_virtual_machine.example.vm_name
}

output "admin_username" {
  value = azurerm_linux_virtual_machine.example.admin_username
}

output "network_interface_ids"{
  value = azurerm_linux_virtual_machine.example.network_interface_ids
}

output "os_disk"{
  value = azurerm_linux_virtual_machine.example.os_disk
}

output "tags"{
  value = azurerm_linux_virtual_machine.example.tags
}

output "resource_group_name"{
  value = azurerm_linux_virtual_machine.example.resource_group_name
}