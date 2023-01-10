output "virtual_network_id" {
  value = azurerm_network_interface.example.id
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.linux_vm.name
}

output "source_image_reference_offer" {
  value = azurerm_linux_virtual_machine.linux_vm.source_image_reference
}

output "managed_disk_name" {
  value = azurerm_linux_virtual_machine.linux_vm.name
}
output "managed_disk_size_gb" {
  value = azurerm_managed_disk.managed_disk.disk_size_gb
}

output "tags" {
  value = azurerm_managed_disk.managed_disk.tags
}

output "storage_account_type"{
    value = azurerm_managed_disk.managed_disk.storage_account_type
}

output "managed_disk_create_option" {
    value = azurerm_managed_disk.managed_disk.create_option
}

output "image_reference_id" {
  value  = azurerm_managed_disk.managed_disk.image_reference_id
}

output "managed_disk_id" {
  value = azurerm_virtual_machine_data_disk_attachment.disk_attachment.managed_disk_id
}

output "virtual_machine_id" {
  value = azurerm_virtual_machine_data_disk_attachment.disk_attachment.virtual_machine_id
}

output "lun" {
  value = azurerm_virtual_machine_data_disk_attachment.disk_attachment.lun
}

output "caching" {
  value = azurerm_virtual_machine_data_disk_attachment.disk_attachment.caching
}
