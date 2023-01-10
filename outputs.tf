output "virtual_network_id" {
value = azurerm_network_interface.example.id
}

output "vm_name" {
    value = azurerm_linux_virtual_machine.example.name
}

output "source_image_reference_offer" {
    value = azurerm_linux_virtual_machine.example.source_image_reference
}

# output "source_image_reference_sku" {
#     value = azurerm_linux_virtual_machine.example.source_image_reference_sku
# }

output "source_image_reference_version" {
    value = azurerm_linux_virtual_machine.example.source_image_reference
}

# output "source_image_reference_publisher" {
#     value = azurerm_linux_virtual_machine.example.source_image_reference_publisher
# }