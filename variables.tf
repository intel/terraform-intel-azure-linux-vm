########################
####     Intel      ####
########################

# See policies.md, we recommend  Intel Xeon 3rd Generation Scalable processors (code-named Ice Lake)
# General Purpose: Standard_D2_v5, Standard_D4_v5, Standard_D8_v5, Standard_D16_v5, Standard_D32_v5, Standard_D48_v5, Standard_D64_v5, Standard_D96_v5
# Memory Optimized: Standard_E2_v5, Standard_E4_v5, Standard_E8_v5, Standard_E16_v5, Standard_E20_v5, Standard_E32_v5, Standard_E48_v5, Standard_E64_v5, Standard_E96_v5, Standard_E104i_v5
# See more:
# https://learn.microsoft.com/en-us/azure/virtual-machines/dv5-dsv5-series
# https://learn.microsoft.com/en-us/azure/virtual-machines/ev5-esv5-series
# https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/#pricing

variable "virtual_machine_size" {
  description = "The SKU that will be configured for the provisioned virtual machine"
  type        = string
  default     = "Standard_D2_v5"
}


########################
####    Required    ####
########################

variable "admin_username" {
  description = "The username of the local administrator used for the virtual machine"
  type        = string
  default     = "adminuser"
}

variable "admin_password" {
  description = "The Password which should be used for the local-administrator on this virtual machine"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.admin_password) >= 8
    error_message = "The admin_password value must be at least 8 characters in length"
  }
}

variable "virtual_network_name" {
  description = "Name of the preconfigured virtual network"
  type        = string
}

variable "vm_name" {
  description = "The unique name of the Linux virtual machine"
  type        = string
  default     = "example-vm"
}

variable "azurerm_network_interface_name" {
  description = "The name of the network interface. Changing this forces a new resource to be created"
  type        = string
}

variable "azurerm_resource_group_name" {
  description = "Name of the resource group to be imported"
  type        = string
}

variable "location" {
  description = "The Azure location where the Linux virtual machine will be provisioned"
  type        = string
  default     = "eastus"
}
variable "os_disk_name" {
  description = "The name which should be used for the internal OS disk"
  type        = string
  default     = "example_disk_name"
}

variable "os_disk_caching" {
  description = "The type of caching which should be used for the internal OS disk. Possible values are 'None', 'ReadOnly' and 'ReadWrite'"
  type        = string
  default     = "ReadOnly"
}

variable "os_disk_storage_account_type" {
  description = "The type of storage account which should back this the internal OS disk. Possible values include Standard_LRS, StandardSSD_LRS and Premium_LRS"
  type        = string
  default     = "Standard_LRS"
}

variable "source_image_reference_offer" {
  description = " Specifies the offer of the image used to create the virtual machine"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "source_image_reference_sku" {
  description = "Specifies the SKU of the image used to create the virtual machine"
  type        = string
  default     = "22_04-lts-gen2"
}

variable "source_image_reference_publisher" {
  description = "Specifies the publisher of the image used to create the virtual machine"
  type        = string
  default     = "Canonical"
}

variable "source_image_reference_version" {
  description = "Specifies the version of the image used to create the virtual machine"
  type        = string
  default     = "latest"
}

variable "ip_configuration_name" {
  description = "A name for the IP with the network interface configuration"
  type        = string
  default     = "internal"
}

variable "ip_configuration_public_ip_address_id" {
  description = "Reference to a public IP address for the NIC"
  type        = string
  default     = null
}

variable "ip_configuration_private_ip_address_allocation" {
  description = "The allocation method used for the private IP address. Possible values are Dynamic and Static"
  type        = string
  default     = "Dynamic"
  #Dynamic means "An IP is automatically assigned during creation of this Network Interface"; Static means "User supplied IP address will be used"
}

########################
####     Other      ####
########################

variable "admin_ssh_key" {
  type    = list(any)
  default = []
}

variable "route_tables_ids" {
  description = "A map of subnet name for the route table ids"
  type        = map(string)
  default     = {}
}


variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(any)
  default = {}
}

variable "identity" {
  type = object({
    identity_ids = optional(list(string))
    principal_id = optional(string)
    tentant_id   = optional(string)
    type         = optional(string, "SystemAssigned")
  })
  default = {}
}

variable "write_accelerator_enabled" {
  description = "Should write accelerator be enabled for this OS disk? Defaults to false"
  type        = bool
  default     = false
}

variable "disk_size_gb" {
  description = "The size of the iternal OS disk in GB, if you wish to vary from the size used in the image this virtual machine is sourced from"
  type        = string
  default     = null
}

variable "priority" {
  description = "Specifies the priority of this virtual machine. Possible values are Regular and Spot. Defaults to Regular"
  type        = string
  default     = "Regular"
}

variable "eviction_policy" {
  description = "Specifies what should happen when the Virtual Machine is evicted for price reasons when using a Spot instance. Possible values are Deallocate and Delete"
  type        = string
  default     = "Deallocate"
}

variable "max_bid_price" {
  description = "The maximum price you're willing to pay for this virtual machine, in US Dollars; which must be greater than the current spot price. If this bid price falls below the current spot price the virtual machine will be evicted using the eviction_policy"
  default     = "-1"
}

variable "disable_password_authentication" {
  description = "Boolean that determines if password authentication be disabled on this virtual machine."
  type        = bool
  default     = true
}
