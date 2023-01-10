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
#     value = azurerm_managed_disk.managed_disk.managed_disk_gallery_image_reference_id
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

