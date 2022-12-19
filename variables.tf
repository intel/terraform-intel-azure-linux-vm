variable "admin_username" {
  type        = string
  description = "The username of the local administrator used for the Virtual Machine"
  default     = "adminuser"
}

variable "admin_password" {
  description = "The Password which should be used for the local-administrator on this Virtual Machine"
  default     = null
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.admin_password) >= 8
    error_message = "The admin_password value must be at least 8 characters in length."
  }
}
variable "vm_name" {
  type        = string
  description = "The name of the Linux Virtual Machine"
  default     = "example-vm"
}

variable "virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "mssql"
}

variable "route_tables_ids" {
  description = "A map of subnet name to Route table ids"
  type        = map(string)
  default     = {}
}

variable "dns_servers" {
  description = "The DNS servers to be used with vNet."
  type        = list(string)
  default     = []
}

variable "nsg_ids" {
  description = "A map of subnet name to Network Security Group IDs"
  type        = map(string)

  default = {
  }
}

variable "azurerm_network_interface_name" {
  default = "kinder_testing"
  type    = string
}

# type = list(string)
#     description = "network interface id"
#     default = ["/subscriptions/d4ab7583-eee6-45fe-9487-a7a0b59a389a/resourceGroups/rg-intel-csa/providers/Microsoft.Network/networkInterfaces/test-bc924_z1"]
# }

variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
  default     = ["10.3.0.0/24"]
}

variable "subnet_name" {
  description = "A list of public subnets inside the vNet."
  type        = string
  default     = "default"
}
variable "subnet_delegation" {
  description = "A map of subnet name to delegation block on the subnet"
  type        = map(map(any))
  default     = {}
}

#variable "subnet_enforce_private_link_endpoint_network_policies" {
#description = "A map of subnet name to enable/disable private link endpoint network policies on the subnet."
#type        = map(bool)
#default     = {}
#}

#variable "subnet_enforce_private_link_service_network_policies" {
#description = "A map of subnet name to enable/disable private link service network policies on the subnet."
#type        = map(bool)
#default     = {}
#}

variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
  default     = ["10.3.0.0/24"]
}

variable "virtual_machine_size" {
  type        = string
  description = "The SKU which should be used for this Virtual Machine"
  default     = "Standard_D2_v5"
}

variable "location" {
  description = "location of the default region"
  default     = "centralus"
}

variable "azurerm_resource_group_name" {
  description = "Name of the resource group to be imported."
  type        = string
  nullable    = false
  default     = "rg-intel-csa"
}

variable "vnet_location" {
  description = "The location of the vnet to create."
  type        = string
  default     = "eastus"
}

variable "vnet_tags" {
  description = "The tags to associate with network and subnets"
  type        = map(string)

  default = {
    environment = "testing"
  }
}

variable "nic_name" {
  description = "Name of the network interface"
  type        = string
  default     = "example-nic"
}

variable "ip_configuration_subnet_id" {
  description = "The ID of the Subnet where this Network Interface should be located in."
  type        = string
  default     = "testing"
}

variable "ip_configuration_name" {
  description = "A name for IP Configuration"
  type        = string
  default     = "internal"
}

variable "ip_configuration_public_ip_address_id" {
  description = "Reference to a public IP Address for the NIC."
  type        = string
  default     = null
}

variable "ip_configuration_private_ip_address_allocation" {
  description = "Reference to a private IP Address for the NIC."
  type        = string
  default     = "Dynamic"
}

variable "enable_ip_forwarding" {
  description = "."
  type        = bool
  default     = false
}

variable "enable_accelerated_networking" {
  description = ""
  type        = bool
  default     = false
}

variable "internal_dns_name_label" {
  description = ""
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(any)
  default = {
    owner    = "kinder.wischmeier@intel.com"
    duration = "4"
  }
}

variable "os_disk_name" {
  description = "The name which should be used for the Internal OS Disk"
  default     = null
}

variable "os_disk_caching" {
  description = "The Type of Caching which should be used for the Internal OS Disk. Possible values are `None`, `ReadOnly` and `ReadWrite`"
  default     = "ReadOnly"
}

variable "os_disk_storage_account_type" {
  description = "The Type of Storage Account which should back this the Internal OS Disk. Possible values include Standard_LRS, StandardSSD_LRS and Premium_LRS."
  default     = "Standard_LRS"
}

variable "disk_size_gb" {
  description = ""
  default     = null
}

variable "enable_os_disk_write_accelerator" {
  description = ""
  default     = false
}

variable "source_image_reference_publisher" {
  description = ""
  default     = "Canonical"
  type        = string
}

variable "source_image_reference_offer" {
  description = ""
  default     = "0001-com-ubuntu-server-jammy"
  type        = string
}

variable "source_image_reference_sku" {
  description = ""
  default     = "22_04-lts-gen2"
  type        = string
}

variable "source_image_reference_version" {
  description = ""
  default     = "latest"
  type        = string
}

variable "azurerm_resource_group" {
  default = "rg-intel-csa"
}