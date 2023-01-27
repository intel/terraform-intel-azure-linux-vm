<p align="center">
  <img src="./images/logo-classicblue-800px.png" alt="Intel Logo" width="250"/>
</p>

# Intel® Cloud Optimization Modules for Terraform  

© Copyright 2022, Intel Corporation

## HashiCorp Sentinel Policies

This file documents the HashiCorp Sentinel policies that apply to this module

## Policy 1

Description: The configured "virtual_machine_size" should be an Intel Xeon 3rd Generation(code-named Ice Lake) Scalable processors

Resource type: azurerm_linux_virtual_machine

Parameter: virtual_machine_size

Allowed Types

- **Compute Optimized:** 
- **Storage Optimized:** Standard_L8s_v3, Standard_L16s_v3, Standard_L32s_v3, Standard_L48s_v3, Standard_L64s_v3, Standard_L80s_v3, 
- **General Purpose:**  Standard_D2_v5, Standard_D4_v5, Standard_D8_v5, Standard_D16_v5, Standard_D32_v5, Standard_D48_v5, Standard_D64_v5, Standard_D96_v5, Standard_D2s_v5, Standard_D4s_v5, Standard_D8s_v5, Standard_D16s_v5, Standard_D32s_v5, Standard_D48s_v5, Standard_D64s_v5, Standard_D96s_v5, Standard_D2d_v5, Standard_D4d_v5, Standard_D8d_v5, Standard_D16d_v5, Standard_D32d_v5, Standard_D48d_v5, Standard_D64d_v5, Standard_D96d_v5, Standard_D2ds_v5, Standard_D4ds_v5, Standard_D8ds_v5, Standard_D16ds_v5, Standard_D32ds_v5, Standard_D48ds_v5, Standard_D64ds_v5, Standard_D96ds_v5, Standard_DC1s_v3, Standard_DC2s_v3, Standard_DC4s_v3, Standard_DC8s_v3, Standard_DC16s_v3, Standard_DC24s_v3, Standard_DC32s_v3, Standard_DC48s_v3, Standard_DC1ds_v3, Standard_DC2ds_v3, Standard_DC4ds_v3, Standard_DC8ds_v3, Standard_DC16ds_v3, Standard_DC24ds_v3, Standard_DC32ds_v3, Standard_DC48ds_v3
- **Memory Optimized:** Standard_E2_v5, Standard_E4_v5, Standard_E8_v5, Standard_E16_v5, Standard_E20_v5, Standard_E32_v5, Standard_E48_v5, Standard_E64_v5, Standard_E96_v5, Standard_E104i_v5, Standard_E2s_v5, Standard_E4s_v5, Standard_E8s_v5, Standard_E16s_v5, Standard_E20s_v5, Standard_E32s_v5, Standard_E48s_v5, Standard_E64s_v5, Standard_E96s_v5, Standard_E104is_v5
- **Accelerated Computing:** 


## Links
https://azure.microsoft.com/en-us/products/virtual-machines/linux/
