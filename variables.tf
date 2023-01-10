variable "admin_username" {
  description = "The username of the local administrator used for the Virtual Machine"
  type        = string
  default     = "adminuser"
}

variable "admin_password" {
  description = "The Password which should be used for the local-administrator on this Virtual Machine"
  type        = string
  default     = null
  sensitive   = true
  validation {
    condition     = length(var.admin_password) >= 8
    error_message = "The admin_password value must be at least 8 characters in length."
  }
}
variable "vm_name" {
  description = "The unique name of the Linux Virtual Machine"
  type        = string
  default     = "example-vm"
}

variable "virtual_network_name" {
  description = "Name of the preconfigured virtual network"
  type        = string
  default     = "kinder-testing"
}

variable "route_tables_ids" {
  description = "A map of subnet name for the route table ids"
  type        = map(string)
  default     = {}
}

variable "azurerm_network_interface_name" {
   description = "The name of the Network Interface. Changing this forces a new resource to be created."
  type    = string
  default = "kinder-testing"
}

variable "subnet_name" {
  description = "Name of the subnet existing in virtual network"
  type        = string
  default     = "default"
}

variable "virtual_machine_size" {
  description = "The SKU which should be used for this Virtual Machine"
  type        = string
  default     = "Standard_D2_v5"
}

variable "location" {
  description = "The Azure location where the Linux Virtual Machine should exist"
  type        = string
  default     = "eastus"
}

variable "azurerm_resource_group_name" {
  description = "Name of the resource group to be imported."
  type        = string
  default     = "kinder-testing"
}
variable "ip_configuration_name" {
  description = "A name for the IP with the network interface configuration"
  type        = string
  default     = "internal"
}

variable "ip_configuration_public_ip_address_id" {
  description = "Reference to a public IP Address for the NIC"
  type        = string
  default     = null
}

variable "ip_configuration_private_ip_address_allocation" {
  description = "The allocation method used for the Private IP Address. Possible values are Dynamic and Static"
  type        = string
  default     = "Dynamic"
  #Dynamic means "An IP is automatically assigned during creation of this Network Interface"; Static means "User supplied IP address will be used"

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
  type        = string
  default     = "testing"
}

variable "os_disk_caching" {
  description = "The Type of Caching which should be used for the Internal OS Disk. Possible values are `None`, `ReadOnly` and `ReadWrite`"
  type        = string
  default     = "ReadOnly"
}

variable "os_disk_storage_account_type" {
  description = "The Type of Storage Account which should back this the Internal OS Disk. Possible values include Standard_LRS, StandardSSD_LRS and Premium_LRS."
  type        = string
  default     = "Standard_LRS"
}

variable "write_accelerator_enabled" {
  description = "Should Write Accelerator be Enabled for this OS Disk? Defaults to false"
  type        = bool
  default     = false
}

variable "disk_size_gb" {
  description = "The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine is sourced from"
  type        = string
  default     = null
}

variable "source_image_reference_publisher" {
  description = "Specifies the publisher of the image used to create the virtual machines"
  type        = string
  default     = "Canonical"
}

variable "source_image_reference_offer" {
  description = " Specifies the offer of the image used to create the virtual machines"
  default     = "0001-com-ubuntu-server-jammy"
  type        = string
}

variable "source_image_reference_sku" {
  description = "Specifies the SKU of the image used to create the virtual machines"
  default     = "22_04-lts-gen2"
  type        = string
}

variable "source_image_reference_version" {
  description = "Specifies the version of the image used to create the virtual machines"
  type        = string
  default     = "latest"
}

# variable "azurerm_ssh_public_key_name" {
#   description = "The name which should be used for this SSH Public Key. Changing this forces a new SSH Public Key to be created."
#   type        = string
#   default     = ""
# }

# variable "azurerm_ssh_public_key_location" {
#   description = "The Azure Region where the SSH Public Key should exist. Changing this forces a new SSH Public Key to be created."
#   type = string
#   default = ""
# }

# variable "azurerm_ssh_public_key_public_key" {
#   description = "SSH public key used to authenticate to a virtual machine through ssh. the provided public key needs to be at least 2048-bit and in ssh-rsa format."
#   type = string
#   default = "value"
# }

