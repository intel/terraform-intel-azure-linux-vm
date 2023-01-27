variable "priority" {
  description = "Specifies the priority of this virtual machine. Possible values are regular and spot"
  type        = string
  default     = "Spot"
}

variable "eviction_policy" {
  description = "Specifies what should happen when the virtual machine is evicted for price reasons when using a spot instance. Possible values are Deallocate and Delete"
  type        = string
  default     = "Deallocate"
}

variable "max_bid_price" {
  description = "The maximum price you're willing to pay for this virtual machine, in US dollars; which must be greater than the current spot price"
  #If this bid price falls below the current spot price the Virtual Machine will be evicted using the eviction_policy"
  type    = number
  default = 0.0874
}

variable "admin_password" {
  description = "The Password which should be used for the local-administrator on this virtual machine"
  default     = null
  type        = string
}