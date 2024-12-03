############################################################################################
# Replace the default values with your own values - your trustauthority_api_key (token)    #
############################################################################################
# Variable for trustauthority_api_key
variable "trustauthority_api_key" {
  description = "trustauthority_api_key"
    type        = string
    default     = "<YOUR ITA TOKEN HERE>"
}

######REQUIRED variables that have default alrady set but you can change as needed########
variable "azurerm_resource_group_name" {
  description = "Name of the resource group to be imported"
  type        = string
  default     = "terraform-testing-rg"
}

variable "region" {
  description = "Target Azure region to deploy VM in."
  type        = string
  default     = "eastus2"
}

variable "azurerm_virtual_network_name" {
  description = "Name of the preconfigured virtual network"
  type        = string
  default     = "vm-vnet1"
}

variable "virtual_network_resource_group_name" {
  description = "Name of the resource group of the virtual network"
  type        = string
  default     = "terraform-testing-rg"
}

variable "azurerm_subnet_name" {
  description = "The name of the preconfigured subnet"
  type        = string
  default     = "default"
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

############OTHER Variables that will be created by this module############
variable "azurerm_key_vault" {
  description = "Name of the Azure Key Vault"
  type        = string
  default     = "tdxitakeyvault1234567890"
}

variable "azurazurerm_key_vault_key" {
  description = "Name of the Azure Key Vault Key"
  type        = string
  default     = "generated-certificate"
}

