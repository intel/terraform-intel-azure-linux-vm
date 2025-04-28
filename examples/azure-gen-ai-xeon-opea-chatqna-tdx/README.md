<p align="center">
   <img src="https://github.com/intel/terraform-intel-azure-linux-vm/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel® Optimized Cloud Modules for Terraform

© Copyright 2024, Intel Corporation

## Intel AMX, Intel TDX, Azure Standard_DCes_v5 Instance, and Open Platform for Enterprise AI (OPEA) ChatQnA Example

**NOTE:**

- **Standard_DCes_v6 is currently in Azure Public Preview, thus make sure your subscription has access to it and is available in your region.**
--These VMs are available in West Europe, East US, West US, and West US 3 as of April 2025--

This demo will showcase Retrieval Augmented Generation (RAG) CPU inference using Intel® 5th Generation Xeon® Scalable processors (Emeralad Rapids) featuring Intel® Trust Domain Extensions (TDX) and Intel® AMX for AI acceleration on Azure using the OPEA ChatQnA Example.

For more information about OPEA, go [here](https://opea.dev/). For more information on this specific example, go [here](https://github.com/opea-project/GenAIExamples/tree/main/ChatQnA).

## Pre-Requisites - Modify variables.tf with the following before running the Terraform Module

1. Your Public IP Address/32(<https://whatismyipaddress.com/>)
2. Existing Azure Resource Group name
3. Existing Azure Virtual Network name
4. Existing Azure Subnet name
5. Existing Hugging Face Token. [Instructions for acquiring token](https://huggingface.co/docs/hub/en/security-tokens)


```hcl

###########################################################################################################################
## THESE RESOURCES MUST ALREADY EXIST. REPLACE DEFAULTS WITH YOUR VALUES                                                 ##
###########################################################################################################################

# Replace values on variables.tf with your own values. And remove comment "#" from default.

# USE https://whatismyipaddress.com/ to find your IP
variable "source_address_prefix" {
  description = "The source address prefix"
  type        = string
  #default     = "192.55.55.48/32" #Just an example, please replace with your IP. USE https://whatismyipaddress.com/ to find your IP
}

variable "azurerm_resource_group_name" {
  description = "Name of the resource group to be imported"
  type        = string
  #default     = "ai-opea-chatqna-rg"
}

variable "region" {
  description = "Target Azure region to deploy VM in."
  type        = string
  #default     = "eastus2"
}

variable "azurerm_virtual_network_name" {
  description = "Name of the preconfigured virtual network"
  type        = string
  #default     = "ai-opea-chatqna-vnet1"
}

variable "virtual_network_resource_group_name" {
  description = "Name of the resource group of the virtual network"
  type        = string
  #default     = "ai-opea-chatqna-rg"
}

variable "azurerm_subnet_name" {
  description = "The name of the preconfigured subnet"
  type        = string
  #default     = "default"
}

# Variable for Huggingface Token
variable "huggingface_token" {
  description = "Huggingface Token"
  type        = string
  #default     = "hf_your_token"
}
```

## Usage from command line - Assumes you have Git, Azure CLI, and Terraform installed

```bash
# Clone the Repo
git clone https://github.com/intel/terraform-intel-azure-linux-vm.git

# Change into the `examples/azure-gen-ai-xeon-opea-chatqna` example folder
cd terraform-intel-azure-linux-vm/examples/azure-gen-ai-xeon-opea-chatqna

# Run the Terraform Commands below to deploy the demos.
terraform init
terraform plan
terraform apply
```

NOTE: If you get this error: **"The property 'securityProfile.encryptionAtHost' is not valid because the 'Microsoft.Compute/EncryptionAtHost' feature is not enabled for this subscription."**. Make sure you EncryptionAtHost is registered for your subscription.

You can issue following AZ CLI command:

```az feature register --namespace Microsoft.Compute --name EncryptionAtHost```

## Usage from Azure Cloud Shell

Open your Azure account and enter Azure Cloud Shell.

At the command prompt enter in in these command prompts to install Terraform into the Azure Cloud Shell

```bash
# Setup Terraform on Azure Cloud Shell
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
mkdir ~/bin
ln -s ~/.tfenv/bin/* ~/bin/
tfenv install 1.3.0
tfenv use 1.3.0
```

```bash
# Clone the Repo
git clone https://github.com/intel/terraform-intel-azure-linux-vm.git

# Change into the `examples/azure-gen-ai-xeon-opea-chatqna` example folder
cd terraform-intel-azure-linux-vm/examples/azure-gen-ai-xeon-opea-chatqna

# Run the Terraform Commands below to deploy the demos.
terraform init
terraform plan
terraform apply
```

## Accessing the Demo

**NOTE: Wait ~15 minutes for the recipe to build and launch the containers before continuing.**

You can access the demos using the following:

- OPEA ChatQnA: `http://yourpublicip:5174`

- Note: This module is created using the Standard_DC64es_v6 instance size, you can change your instance type by modifying the **virtual_machine_size = "Standard_DC64es_v6"** in the main.tf under the **azurerm_linux_virtual_machine** section of the code. If you just change to an 8xlarge and then run **terraform apply** the module will destroy the old instance and rebuild with a larger instance size.

## Deleting the Demo

To delete the demo, run `terraform destroy` to delete all resources created.

## Considerations

- The Azure region where this example is run should have a default virtual network
