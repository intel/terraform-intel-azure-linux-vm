variable "azure_subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}
variable "azure_client_id" {
  type        = string
  description = "Azure Client ID"
}
variable "azure_client_secret" {
  type        = string
  description = "Azure Client Secret"
}
variable "azure_tenant_id" {
  type        = string
  description = "Azure Tenant ID"
}

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
variable "name" {
  type        = string
  description = "The name of the Linux Virtual Machine"
  #name        = "example-vm"
}
