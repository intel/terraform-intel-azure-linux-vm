#variable "azure_subscription_id" {
  #type        = string
  #description = "Azure Subscription ID"
#}
#variable "azure_client_id" {
  #type        = string
  #description = "Azure Client ID"
#}
#variable "azure_client_secret" {
  #type        = string
  #description = "Azure Client Secret"
#}
#variable "azure_tenant_id" {
  #type        = string
  #description = "Azure Tenant ID"
#}

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

variable "vnet_name" {
  description = "Name of the vnet to create"
  type        = string
  default     = "example-network"
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

variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
  default     = ["10.0.0.0/16"]
}

variable "subnet_names" {
  description = "A list of public subnets inside the vNet."
  type        = list(string)
  default     = ["subnet1", "subnet2", "subnet3"]
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

variable "subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "virtual_machine_size" {
    type        = string
    description = "The SKU which should be used for this Virtual Machine"
    default        = "Standard_D2_v5"
}

variable "location" {
  description = "location of the default region"
  default = "East US"
}

variable "resource_group_name" {
  description = "Name of the resource group to be imported."
  type        = string
  nullable    = false
}

variable "vnet_location" {
  description = "The location of the vnet to create."
  type        = string
  nullable    = false
}

variable "vnet_tags" {
  description = "The tags to associate with network and subnets"
  type = map(string)  
    
  default = {
    environment = "testing"
  }
}