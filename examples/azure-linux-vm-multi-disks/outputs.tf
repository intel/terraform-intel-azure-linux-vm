output "virtual_network_id" {
  description = "The ID of the virtual network."
  value = azurerm_network_interface.nic.id
}

output "vm_name" {
  description = "Specifies the name of the virtual network."
  value = azurerm_linux_virtual_machine.linux_vm.name
}

output "source_image_reference_offer" {
  description = " Specifies the offer of the image used to create the virtual machines."
  value = azurerm_linux_virtual_machine.linux_vm.source_image_reference
}

output "managed_disk_name" {
  description = "Specifies the name of the managed disk"
  value = azurerm_linux_virtual_machine.linux_vm.name
}
output "managed_disk_size_gb" {
  description = "Specifies the size of the managed disk to create in gigabytes"
  value = azurerm_managed_disk.managed_disk.disk_size_gb
}

output "tags" {
  value = azurerm_managed_disk.managed_disk.tags
}

output "storage_account_type" {
  description = "The type of storage to use for the managed disk. Possible values are Standard_LRS, StandardSSD_ZRS, Premium_LRS, PremiumV2_LRS, Premium_ZRS, StandardSSD_LRS or UltraSSD_LRS."
  value = azurerm_managed_disk.managed_disk.storage_account_type
}

output "managed_disk_create_option" {
  description = "The method to use when creating the managed disk. "
  value = azurerm_managed_disk.managed_disk.create_option
}

output "image_reference_id" {
  description = "ID of an existing platform/marketplace disk image to copy when create_option is FromImage"
  value = azurerm_managed_disk.managed_disk.image_reference_id
}

output "managed_disk_id" {
  description = "The ID of the managed disk."
  value = azurerm_virtual_machine_data_disk_attachment.disk_attachment.managed_disk_id
}

output "virtual_machine_id" {
  description = " A 128-bit identifier which uniquely identifies this virtual machine."
  value = azurerm_virtual_machine_data_disk_attachment.disk_attachment.virtual_machine_id
}

output "lun" {
  description = " The logical unit number of the data disk, which needs to be unique within the virtual machine."
  value = azurerm_virtual_machine_data_disk_attachment.disk_attachment.lun
}

output "caching" {
  description = "Specifies the caching requirements for this data disk. Possible values include None, ReadOnly and ReadWrite."
  value = azurerm_virtual_machine_data_disk_attachment.disk_attachment.caching
}
