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

variable "azurerm_resource_group_name" {
  description = "Name of the resource group to be imported"
  type        = string
  default     = "DS-TDXTERRAFORM"
}

variable "virtual_network_resource_group_name" {
  description = "Name of the resource group of the virtual network"
  type        = string
  default     = "DS-TDXTERRAFORM"
}

variable "azurerm_virtual_network_name" {
  description = "Name of the preconfigured virtual network"
  type        = string
  default     = "dstdxvnet"
}

variable "azurerm_subnet_name" {
  description = "The name of the preconfigured subnet"
  type        = string
  default     = "dstdxsubnet"
}

variable "keyvault_name" {
  description = "The name of the azure key vault"
  type        = string
  default     = "ds-tdx-examplekeyvault"
}

variable "virtual_machine_size" {
  description = "The SKU that will be configured for the provisioned virtual machine"
  type        = string
  default     = "Standard_DC2es_v5"
}

variable "vm_name" {
  description = "The unique name of the Linux virtual machine"
  type        = string
  default     = "ds-tdx-linuxvm1"
}

##########################################################
####     Intel Confidential VM with TDX Variable      ####
##########################################################

#Required - Set the zone to the supported zone where Intel Confidential Computing VM with TDX is available
#This is optional - set it to "false" to disable it


