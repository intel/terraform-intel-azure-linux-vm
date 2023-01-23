variable "admin_password" {
  description = "The Password which should be used for the local-administrator on this virtual machine"
  default     = null
  type        = string
}

variable "managed_disk_name" {
  description = "Specifies the name of the managed disk. Changing this forces a new resource to be created"
  type        = string

}

variable "managed_disk_storage_account_type" {
  description = "The type of storage to use for the managed disk. Possible values are Standard_LRS, StandardSSD_ZRS, Premium_LRS, PremiumV2_LRS, Premium_ZRS, StandardSSD_LRS or UltraSSD_LRS"
  type        = string
  default     = "Standard_LRS"
}

variable "managed_disk_create_option" {
  description = "The method to use when creating the managed disk. Changing this forces a new resource to be created. Possible values include: import, empty, copy, fromimage, restore, or upload"
  type        = string
  default     = "Empty"
}
variable "managed_disk_size_gb" {
  description = "Required for a new managed disk. Specifies the size of the managed disk to create in gigabytes. If create_option is Copy or FromImage, then the value must be equal to or greater than the source's size. The size can only be increased"
  type        = number
  default     = 8
}

variable "managed_disk_iops_read_write" {
  description = "The number of IOPS allowed for this disk; only settable for UltraSSD disks and PremiumV2 disks. One operation can transfer between 4k and 256k bytes"
  type        = number
  default     = 500
}

variable "managed_disk_upload_size_bytes" {
  description = " Specifies the size of the managed disk to create in bytes. Required when create_option is Upload. The value must be equal to the source disk to be copied in bytes. Source disk size could be calculated with ls -l or wc -c"
  type        = number
  default     = 8
}

variable "lun" {
  description = "The logical unit number of the data disk, which needs to be unique within the virtual machine. Changing this forces a new resource to be created"
  default     = 10
  type        = string
}

variable "managed_disk_image_reference_id" {
  description = "ID of an existing platform/marketplace disk image to copy when create_option is FromImage. This field cannot be specified if gallery_image_reference_id is specified"
  type        = string
  default     = null
}

