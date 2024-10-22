
variable "admin_password" {
  description = "The Password which should be used for the local-administrator on this virtual machine"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.admin_password) >= 8
    error_message = "The admin_password value must be at least 8 characters in length"
  }
}

variable "region" {
  description = "Target Azure region to deploy VM in."
  type        = string
  default     = "eastus2"
}

# Variable for Huggingface Token
variable "huggingface_token" {
  description = "Huggingface Token"
  default     = " <YOUR HUGGINGFACE TOKEN> "
  type        = string
}