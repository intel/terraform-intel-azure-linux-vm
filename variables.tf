########################
####     Intel      ####
########################

# See policies.md, we recommend 5th Generation Intel® Xeon® Platinum (Emerald Rapids) processor for Non-Confidential Computing VMs and Intel® 4th Generation Xeon® Scalable Sapphire Rapids, processors featuring Intel Trusted Domain Extensions (TDX) for Confidential Computing VMs. 
# Storage Optimized (Only Intel Ice Lake available): Standard_L8s_v3, Standard_L16s_v3, Standard_L32s_v3, Standard_L48s_v3, Standard_L64s_v3, Standard_L80s_v3, 
# General Purpose: Standard_D2s_v6, Standard_D4s_v6, Standard_D8s_v6, Standard_D16s_v6, Standard_D32s_v6, Standard_D48s_v6, Standard_D64s_v6, Standard_D96s_v6, Standard_D128s_v6, Standard_D2d_v6, Standard_D4d_v6, Standard_D8d_v6, Standard_D16d_v6, Standard_D32d_v6, Standard_D48d_v6, Standard_D64d_v6, Standard_D96d_v6, Standard_D2ds_v6, Standard_D4ds_v6, Standard_D8ds_v6, Standard_D16ds_v6, Standard_D32ds_v6, Standard_D48ds_v6, Standard_D64ds_v6, Standard_D96ds_v6, Standard_D128ds_v6
# Confidential Computing DC-series VMs: Standard_DC2es_v5, Standard_DC4es_v5, Standard_DC8es_v5, Standard_DC16es_v5, Standard_DC32es_v5, Standard_DC48es_v5, Standard_DC64es_v5, Standard_DC96es_v5
# Confidential Computing EC-series VMs: Standard_EC2es_v5, Standard_EC4es_v5, Standard_EC8es_v5, Standard_EC16es_v5, Standard_EC32es_v5, Standard_EC48es_v5, Standard_EC64es_v5, Standard_EC96es_v5, Standard_EC128es_v5
# Memory Optimized: Standard_Es2_v6, Standard_Es4_v6, Standard_Es8_v6, Standard_Es16_v6, Standard_Es20_v6, Standard_Es32_v6, Standard_Es48_v6, Standard_Es64_v6, Standard_Es96_v6, Standard_E128s_v6, Standard_E192is_v6, Standard_E2ds_v6, Standard_E4ds_v6, Standard_E8ds_v6, Standard_E16ds_v6, Standard_E20ds_v6, Standard_E32ds_v6, Standard_E48ds_v6, Standard_E64ds_v6, Standard_E96ds_v6, Standard_E128ds_v6, Standard_E192ids_v6 
# See more:
# https://learn.microsoft.com/en-us/azure/virtual-machines/dv5-dsv5-series
# https://learn.microsoft.com/en-us/azure/virtual-machines/ev5-esv5-series
# https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/#pricing

variable "virtual_machine_size" {
  description = "The SKU that will be configured for the provisioned virtual machine"
  type        = string
  default     = "Standard_D2s_v6"
}

########################
####    Required    ####
########################


variable "admin_password" {
  description = "The Password which should be used for the local-administrator on this virtual machine"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.admin_password) >= 8
    error_message = "The admin_password value must be at least 8 characters in length"
  }
}

variable "azurerm_virtual_network_name" {
  description = "Name of the preconfigured virtual network"
  type        = string
}

variable "virtual_network_resource_group_name" {
  description = "Name of the resource group of the virtual network"
  type        = string
}

variable "azurerm_resource_group_name" {
  description = "Name of the resource group to be imported"
  type        = string
}

variable "azurerm_subnet_name" {
  description = "The name of the preconfigured subnet"
  type        = string
}

##########################################################
####     Intel Confidential VM with TDX Variable      ####
##########################################################

variable "tdx_flag" {
  description = "Determines whether a VM is TDX Confidential Compute VM"
  type        = bool
  default     = false
}

variable "secure_boot_flag" {
  description = "Enables Secure Boot- recommended TDX Confidential Compute VM"
  type        = bool
  default     = false
}

variable "encryption_at_host_flag" {
  description = "Enables OS Disk Encryption at Host - recommended for TDX Confidential Compute VM"
  type        = bool
  default     = false
}

########################
####     Other      ####
########################

variable "azurerm_network_interface_name" {
  description = "The name of the network interface. Changing this forces a new resource to be created"
  type        = string
  default     = "nic1"
}

variable "azurerm_storage_account_name" {
  description = "The name of the storage account to be used for the boot_diagnostic"
  type        = string
  default     = null
}

variable "os_disk_name" {
  description = "The name which should be used for the internal OS disk"
  type        = string
  default     = "os_disk1"
}

variable "vm_name" {
  description = "The unique name of the Linux virtual machine"
  type        = string
  default     = "vm1"
}

variable "os_disk_caching" {
  description = "The type of caching which should be used for the internal OS disk. Possible values are 'None', 'ReadOnly' and 'ReadWrite'"
  type        = string
  default     = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  description = "The type of storage account which should back this the internal OS disk. Possible values include Standard_LRS, StandardSSD_LRS and Premium_LRS"
  type        = string
  default     = "Premium_LRS"
}

variable "source_image_id" {
  description = "Used for Custom Compute Gallery Images. The ID of the image used to create the virtual machine"
  type        = string
  default     = null
}

variable "source_image_reference" {
  type    = map(any)
  default = null
}

# variable "source_image_reference_offer" {
#   description = " Specifies the offer of the image used to create the virtual machine"
#   type        = string
#   default     = "0001-com-ubuntu-server-jammy"
# }

# variable "source_image_reference_sku" {
#   description = "Specifies the SKU of the image used to create the virtual machine"
#   type        = string
#   default     = "22_04-lts-gen2"
# }

# variable "source_image_reference_publisher" {
#   description = "Specifies the publisher of the image used to create the virtual machine"
#   type        = string
#   default     = "Canonical"
# }

# variable "source_image_reference_version" {
#   description = "Specifies the version of the image used to create the virtual machine"
#   type        = string
#   default     = "latest"
# }

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


variable "admin_username" {
  description = "The username of the local administrator used for the virtual machine"
  type        = string
  default     = "adminuser"
}

variable "admin_ssh_key" {
  type    = list(any)
  default = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(any)
  default = {
  }
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
  description = "The size of the internal OS disk in GB, if you wish to vary from the size used in the image this virtual machine is sourced from"
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
  default     = null
}

variable "max_bid_price" {
  description = "The maximum price you're willing to pay for this virtual machine, in US Dollars; which must be greater than the current spot price. If this bid price falls below the current spot price the virtual machine will be evicted using the eviction_policy"
  default     = "-1"
}

variable "disable_password_authentication" {
  description = "Boolean that determines if password authentication will be disabled on this virtual machine"
  type        = bool
  default     = false
}

variable "enable_boot_diagnostics" {
  description = "Boolean that determines if the boot diagnostics will be enabled on this virtual machine"
  type        = bool
  default     = true
}

variable "custom_data" {
  description = "The Base64-Encoded Custom Data which should be used for this Virtual Machine. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

