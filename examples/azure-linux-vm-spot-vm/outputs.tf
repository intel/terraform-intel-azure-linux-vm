output "virtual_network_id" {
value = azurerm_network_interface.example.id
}

output "vm_name" {
    value = azurerm_linux_virtual_machine.example.name
}

output "max_bid_price" {
    value = azurerm_linux_virtual_machine.example.max_bid_price
}