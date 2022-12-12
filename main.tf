data "azurerm_resource_group" "example" {
  name = var.azurerm_resource_group

}
resource "azurerm_virtual_network" "example" {
  name                = var.vnet_name
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.example.id
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_enabled ? azurerm_public_ip.primary[0].id : ""
  }
}


resource "azurerm_linux_virtual_machine" "example" {
  name                = var.name
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.size
  #subscription_id     = var.azure-subscription-id
  #client_id           = var.azure-client-id
  #client_secret       = var.azure-client-secret
  #tenant_id           = var.azure-tenant-id

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  username = var.admin_username
  password = var.admin_password

  disable_password_authentication = false

  os_disk {
    type                 = string
    caching              = "ReadOnly"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = ":0001-com-ubuntu-server-jammy:"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  size {
    type        = string
    description = "The SKU which should be used for this Virtual Machine"
    size        = "Standard_D2_v5"
  }

}
