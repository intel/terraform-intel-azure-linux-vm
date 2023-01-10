<p align="center">
  <img src="./images/logo-classicblue-800px.png" alt="Intel Logo" width="250"/>
</p>

# Intel® Cloud Optimization Modules for Terraform  

© Copyright 2022, Intel Corporation

## HashiCorp Sentinel Policies

This file documents the HashiCorp Sentinel policies that apply to this module

## Policy 1

Description: The configured "instance_type" should be an Intel Xeon 3rd Generation(code-named Ice Lake) Scalable processors

Resource type: azurerm_linux_virtual_machine

Parameter: instance_type

Allowed Types

- **Compute Optimized:** 
- **Storage Optimized:** 
- **General Purpose:**  
- **Memory Optimized:** 
- **Accelerated Computing:** 


## Links
https://azure.microsoft.com/en-us/products/virtual-machines/linux/
