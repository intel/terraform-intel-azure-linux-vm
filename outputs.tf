output "size" {
  value = azurerm_linux_virtual_machine.linux_vm.size
}
output "location" {
  value = azurerm_linux_virtual_machine.linux_vm.location
}

output "name" {
  value = azurerm_linux_virtual_machine.linux_vm.name
}

output "admin_username" {
  value = azurerm_linux_virtual_machine.linux_vm.admin_username
}

output "network_interface_ids"{
  value = azurerm_linux_virtual_machine.linux_vm.network_interface_ids
}

output "os_disk"{
  value = azurerm_linux_virtual_machine.linux_vm.os_disk
}

output "tags"{
  value = azurerm_linux_virtual_machine.linux_vm.tags
}

output "resource_group_name"{
  value = azurerm_linux_virtual_machine.linux_vm.resource_group_name
}