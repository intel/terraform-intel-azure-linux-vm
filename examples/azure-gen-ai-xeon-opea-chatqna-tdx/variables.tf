###########################################################################################################################
## THESE RESOURCES MUST ALREADY EXIST. REPLACE DEFAULTS WITH YOUR VALUES                                ###################
###########################################################################################################################

# USE https://whatismyipaddress.com/ to find your IP
variable "source_address_prefix" {
  description = "Your Public IP/32. Use https://whatismyipaddress.com/ to find your IP"
  type        = string
  #default     = "3.20.43.52/32" #Just an example, please replace with your IP. USE https://whatismyipaddress.com/ to find your IP
}

variable "azurerm_resource_group_name" {
  description = "Name of the existing resource group to be imported"
  type        = string
  #default     = "terraform-testing-rg-eastus"
}

variable "region" {
  description = "Target Azure region. Should be the same as RG/VNET/Subnet"
  type        = string
  #default     = "eastus"
}

variable "azurerm_virtual_network_name" {
  description = "Name of the existing virtual network"
  type        = string
  #default     = "vnet01"
}

variable "virtual_network_resource_group_name" {
  description = "Name of the existing resource group of the virtual network"
  type        = string
  #default     = "terraform-testing-rg-eastus"
}

variable "azurerm_subnet_name" {
  description = "The name of the existing subnet"
  type        = string
  #default     = "default"
}

# Variable for Huggingface Token
variable "huggingface_token" {
  description = "Huggingface Token"
  type        = string
  #default     = "Huggingface Token"
}

###########################################################################################################################
###########################################################################################################################

## OTHER variables used by this module
variable "azurerm_key_vault" {
  description = "Name of the Azure Key Vault"
  type        = string
  default     = "aiopeanchatqnatdxkv"
}

variable "azurazurerm_key_vault_key" {
  description = "Name of the Azure Key Vault Key"
  type        = string
  default     = "generated-certificate"
}

variable "azurerm_network_interface_name" {
  description = "Name of the preconfigured virtual network"
  type        = string
  default     = "ai-opea-chatqna-nic01"
}

variable "azurerm_network_security_group_name" {
  description = "Name of the network security group"
  type        = string
  default     = "ai-opea-chatqna-nsg"
}

variable "azurerm_public_ip_name" {
  description = "The name of the preconfigured subnet"
  type        = string
  default     = "ai-opea-chatqna-pip"
}

variable "os_disk_name" {
  description = "The name of the OS Disk"
  type        = string
  default     = "ai-opea-chatqna-osdisk1"
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
