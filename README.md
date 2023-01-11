
<p align="center">
  <img src="./images/logo-classicblue-800px.png" alt="Intel Logo" width="250"/>
</p>

# Intel® Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Module name

Azure Linux Virtual Machine

## Usage

See examples folder for code ./examples/azure-linux-vm-spot-vm/main.tf

Example of main.tf

```hcl
# Example of how to pass variable for virtual machine password:
# terraform apply -var="admin_password=..."
# Environment variables can also be used https://www.terraform.io/language/values/variables#environment-variables

# Provision Intel Cloud Optimization Module
module "azure-vm" {
  source = "../../"
  tags = {
    Name     = "my-test-vm-${random_id.rid.dec}"
    Owner    = "OwnerName-${random_id.rid.dec}",
    Duration = "2"
  }
}

```

Run Terraform

```hcl
terraform init  
terraform plan
terraform apply

```

Note that this example may create resources. Run `terraform destroy` when you don't need these resources anymore.

## Considerations  

'''

When admin_password is specified disable_password_authentication must be set to false

Either admin_password or admin_ssh_key must be specified



'''
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.26.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>3.26.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.linux_vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | The Password which should be used for the local-administrator on this Virtual Machine | `string` | `null` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | The username of the local administrator used for the Virtual Machine | `string` | `"adminuser"` | no |
| <a name="input_azurerm_network_interface_name"></a> [azurerm\_network\_interface\_name](#input\_azurerm\_network\_interface\_name) | The name of the Network Interface. Changing this forces a new resource to be created. | `string` | `"kinder-testing"` | no |
| <a name="input_azurerm_resource_group_name"></a> [azurerm\_resource\_group\_name](#input\_azurerm\_resource\_group\_name) | Name of the resource group to be imported. | `string` | `"kinder-testing"` | no |
| <a name="input_disk_size_gb"></a> [disk\_size\_gb](#input\_disk\_size\_gb) | The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine is sourced from | `string` | `null` | no |
| <a name="input_ip_configuration_name"></a> [ip\_configuration\_name](#input\_ip\_configuration\_name) | A name for the IP with the network interface configuration | `string` | `"internal"` | no |
| <a name="input_ip_configuration_private_ip_address_allocation"></a> [ip\_configuration\_private\_ip\_address\_allocation](#input\_ip\_configuration\_private\_ip\_address\_allocation) | The allocation method used for the Private IP Address. Possible values are Dynamic and Static | `string` | `"Dynamic"` | no |
| <a name="input_ip_configuration_public_ip_address_id"></a> [ip\_configuration\_public\_ip\_address\_id](#input\_ip\_configuration\_public\_ip\_address\_id) | Reference to a public IP Address for the NIC | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure location where the Linux Virtual Machine should exist | `string` | `"eastus"` | no |
| <a name="input_os_disk_caching"></a> [os\_disk\_caching](#input\_os\_disk\_caching) | The Type of Caching which should be used for the Internal OS Disk. Possible values are `None`, `ReadOnly` and `ReadWrite` | `string` | `"ReadOnly"` | no |
| <a name="input_os_disk_name"></a> [os\_disk\_name](#input\_os\_disk\_name) | The name which should be used for the Internal OS Disk | `string` | `"testing"` | no |
| <a name="input_os_disk_storage_account_type"></a> [os\_disk\_storage\_account\_type](#input\_os\_disk\_storage\_account\_type) | The Type of Storage Account which should back this the Internal OS Disk. Possible values include Standard\_LRS, StandardSSD\_LRS and Premium\_LRS. | `string` | `"Standard_LRS"` | no |
| <a name="input_route_tables_ids"></a> [route\_tables\_ids](#input\_route\_tables\_ids) | A map of subnet name for the route table ids | `map(string)` | `{}` | no |
| <a name="input_source_image_reference_offer"></a> [source\_image\_reference\_offer](#input\_source\_image\_reference\_offer) | Specifies the offer of the image used to create the virtual machines | `string` | `"0001-com-ubuntu-server-jammy"` | no |
| <a name="input_source_image_reference_publisher"></a> [source\_image\_reference\_publisher](#input\_source\_image\_reference\_publisher) | Specifies the publisher of the image used to create the virtual machines | `string` | `"Canonical"` | no |
| <a name="input_source_image_reference_sku"></a> [source\_image\_reference\_sku](#input\_source\_image\_reference\_sku) | Specifies the SKU of the image used to create the virtual machines | `string` | `"22_04-lts-gen2"` | no |
| <a name="input_source_image_reference_version"></a> [source\_image\_reference\_version](#input\_source\_image\_reference\_version) | Specifies the version of the image used to create the virtual machines | `string` | `"latest"` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | Name of the subnet existing in virtual network | `string` | `"default"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(any)` | <pre>{<br>  "duration": "4",<br>  "owner": "kinder.wischmeier@intel.com"<br>}</pre> | no |
| <a name="input_virtual_machine_size"></a> [virtual\_machine\_size](#input\_virtual\_machine\_size) | The SKU which should be used for this Virtual Machine | `string` | `"Standard_D2_v5"` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Name of the preconfigured virtual network | `string` | `"kinder-testing"` | no |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | The unique name of the Linux Virtual Machine | `string` | `"example-vm"` | no |
| <a name="input_write_accelerator_enabled"></a> [write\_accelerator\_enabled](#input\_write\_accelerator\_enabled) | Should Write Accelerator be Enabled for this OS Disk? Defaults to false | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_source_image_reference_offer"></a> [source\_image\_reference\_offer](#output\_source\_image\_reference\_offer) | n/a |
| <a name="output_source_image_reference_version"></a> [source\_image\_reference\_version](#output\_source\_image\_reference\_version) | n/a |
| <a name="output_virtual_network_id"></a> [virtual\_network\_id](#output\_virtual\_network\_id) | n/a |
| <a name="output_vm_name"></a> [vm\_name](#output\_vm\_name) | n/a |
<!-- END_TF_DOCS -->