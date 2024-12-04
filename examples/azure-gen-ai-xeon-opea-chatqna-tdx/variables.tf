##These resource must be pre-existing on your Azure subscription - change name of the resource as needed###################
###########################################################################################################################
variable "azurerm_resource_group_name" {
  description = "Name of the resource group to be imported"
  type        = string
  default     = "ai-opea-chatqna-rg"
}

variable "region" {
  description = "Target Azure region to deploy VM in."
  type        = string
  default     = "eastus2"
}

variable "azurerm_virtual_network_name" {
  description = "Name of the preconfigured virtual network"
  type        = string
  default     = "ai-opea-chatqna-vnet1"
}

variable "virtual_network_resource_group_name" {
  description = "Name of the resource group of the virtual network"
  type        = string
  default     = "ai-opea-chatqna-rg"
}

variable "azurerm_subnet_name" {
  description = "The name of the preconfigured subnet"
  type        = string
  default     = "default"
}

##OTHER Variables that will be created by this module
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

# Variable for Huggingface Token
variable "huggingface_token" {
  description = "Huggingface Token"
  default     = " <YOUR HUGGINGFACE TOKEN> "
  type        = string
}