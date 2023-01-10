output "virtual_network_id" {
  value = azurerm_network_interface.nic.id
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.linux_vm.name
}

output "source_image_reference_offer" {
  value = azurerm_linux_virtual_machine.linux_vm.source_image_reference
}
output "source_image_reference_version" {
  value = azurerm_linux_virtual_machine.linux_vm.source_image_reference
}