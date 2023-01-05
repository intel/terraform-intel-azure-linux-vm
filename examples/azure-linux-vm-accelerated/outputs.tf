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
# output "managed_disk_size_gb" {
#     value = azurerm_managed_disk.example.managed_disk_size_gb
# }

# output "managed_disk_storage_account_type"{
#     value = azurerm_linux_virtual_machine.linux_vm.storage_account_type
# }

# output "managed_disk_create_option" {
#     value = azurerm_managed_disk.example.managed_disk_create_option
# }
# output "managed_disk_iops_read_write" {
#     value = azurerm_managed_disk.example.managed_disk_iops_read_write
# }

# output "managed_disk_mbps_read_write" {
#     value = azurerm_managed_disk.example.managed_disk_mbps_read_write
# }

# output "managed_disk_upload_size_bytes" {
#     value = azurerm_managed_disk.example.managed_disk_upload_size_bytes
# }

# output "managed_disk_edge_zone" {
#     value = azurerm_managed_disk.example.managed_disk_edge_zone
# }

# output "managed_disk_hyper_v_generation" {
#     value = azurerm_managed_disk.example.managed_disk_hyper_v_generation
# }

# output "managed_disk_image_reference_id" {
#     value = azurerm_managed_disk.example.managed_disk_gallery_image_reference_id
# }

# output "managed_disk_logical_sector_size" {
#     value = azurerm_managed_disk.example.managed_disk_logical_sector_size
# }

# output "managed_disk_os_type" {
#     value = azurerm_managed_disk.example.managed_disk_os_type
# }

# output "managed_disk_source_resource_id" {
#     value = azurerm_managed_disk.example.managed_disk_source_resource_id
# }

