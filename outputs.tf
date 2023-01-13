output "virtual_network_id" {
  description = "The ID of the virtual network."
  value       = azurerm_network_interface.nic.id
}

output "vm_name" {
  description = "Specifies the name of the virtual network."
  value       = azurerm_linux_virtual_machine.linux_vm.name
}

output "source_image_reference_offer" {
  description = " Specifies the offer of the image used to create the virtual machines."
  value       = azurerm_linux_virtual_machine.linux_vm.source_image_reference
}
output "source_image_reference_version" {
  description = " Specifies the version of the image used to create the virtual machines."
  value       = azurerm_linux_virtual_machine.linux_vm.source_image_reference
}