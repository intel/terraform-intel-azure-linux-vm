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
  type        = string
  default     = "kinder-testing"

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
  description = "Name of the pre-configured resource group that will be imported."
  type        = string
  default     = "kinder-testing"
}

variable "ip_configuration_name" {
  description = "A name for the IP with the network interface configuration"
  type        = string
  default     = "internal"
}

variable "ip_configuration_public_ip_address_id" {
  description = "Reference to a public IP Address for the NIC."
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
  description = "A mapping of tags to assign to the resource. Owner and duration required tags are required."
  type        = map(any)
  default = {
    owner    = "kinder.wischmeier@intel.com"
    duration = "4"
  }
}

variable "os_disk_name" {
  description = "The name which should be used for the Internal OS Disk"
  type        = string
  default     = "os_disk"
}

variable "os_disk_caching" {
  description = "The Type of Caching which should be used for the Internal OS Disk. Possible values are `None`, `ReadOnly` and `ReadWrite`"
  type        = string
  default     = "ReadWrite"
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
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "source_image_reference_sku" {
  description = "Specifies the SKU of the image used to create the virtual machines"
  type        = string
  default     = "22_04-lts-gen2"
}

variable "source_image_reference_version" {
  description = "Specifies the version of the image used to create the virtual machines"
  type        = string
  default     = "latest"
}


variable "managed_disk_name" {
  description = "Specifies the name of the Managed Disk. Changing this forces a new resource to be created."
  type        = string
  default     = "testing"

}

variable "managed_disk_storage_account_type" {
  description = "The type of storage to use for the managed disk. Possible values are Standard_LRS, StandardSSD_ZRS, Premium_LRS, PremiumV2_LRS, Premium_ZRS, StandardSSD_LRS or UltraSSD_LRS"
  type        = string
  default     = "Standard_LRS"
}

variable "managed_disk_create_option" {
  description = "The method to use when creating the managed disk. Changing this forces a new resource to be created. Possible values include: import, empty, copy, fromimage, restore, or upload."
  type        = string
  default     = "Empty"
}
variable "managed_disk_size_gb" {
  description = "Required for a new managed disk. Specifies the size of the managed disk to create in gigabytes. If create_option is Copy or FromImage, then the value must be equal to or greater than the source's size. The size can only be increased."
  type        = number
  default     = 8
}

variable "managed_disk_iops_read_write" {
  description = "The number of IOPS allowed for this disk; only settable for UltraSSD disks and PremiumV2 disks. One operation can transfer between 4k and 256k bytes."
  type        = number
  default     = 500
}

variable "managed_disk_upload_size_bytes" {
  description = " Specifies the size of the managed disk to create in bytes. Required when create_option is Upload. The value must be equal to the source disk to be copied in bytes. Source disk size could be calculated with ls -l or wc -c"
  type        = number
  default     = 8
}

variable "lun" {
  description = "The Logical Unit Number of the Data Disk, which needs to be unique within the Virtual Machine. Changing this forces a new resource to be created."
  default     = 10
  type        = string
}

variable "disable_password_authentication" {
  description = "Should Password Authentication be disabled on this Virtual Machine? Defaults to true."
  default     = false
}
variable "managed_disk_image_reference_id" {
  description = "ID of an existing platform/marketplace disk image to copy when create_option is FromImage. This field cannot be specified if gallery_image_reference_id is specified."
  type        = string
  default     = null
}

#  variable "managed_disk_gallery_image_reference_id" {
#   description = "ID of a Gallery Image Version to copy when create_option is FromImage. This field cannot be specified if image_reference_id is specified."
#   type        = string
#  }

#  variable "managed_disk_logical_sector_size" {
#   description = "Logical Sector Size. Possible values are: 512 and 4096. Defaults to 4096. Changing this forces a new resource to be created."
#   type        = number
#  }

#  variable "managed_disk_os_type" {
#   description = "Specify a value when the source of an Import or Copy operation targets a source that contains an operating system. Valid values are Linux or Windows"
#   type        = string
#  }

#  variable "managed_disk_source_resource_id" {
#   description = "The ID of an existing Managed Disk or Snapshot to copy when create_option is Copy or the recovery point to restore when create_option is Restore. Changing this forces a new resource to be created."
#   type        = string
#  }

#  variable "managed_disk_edge_zone" {
#   description = "Specifies the Edge Zone within the Azure Region where this Managed Disk should exist."
#   type = string
#  }

#  variable "managed_disk_hyper_v_generation" {
#   description = "The HyperV Generation of the Disk when the source of an Import or Copy operation targets a source that contains an operating system. Possible values are V1 and V2"
#   type        = string
#  }

#  variable "managed_disk_mbps_read_write" {
#   description = "The bandwidth allowed for this disk; only settable for UltraSSD disks and PremiumV2 disks. MBps means millions of bytes per second."
#   type = number
#  }


