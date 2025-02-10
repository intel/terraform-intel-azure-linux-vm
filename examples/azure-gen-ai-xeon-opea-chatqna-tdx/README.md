<p align="center">
  <img src="https://github.com/intel/terraform-intel-Azure-vm/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel® Optimized Cloud Modules for Terraform

© Copyright 2024, Intel Corporation

## Azure Standard_DC32es_v6 Instance (currently in Azure Public Preview, thus make sure your subscription has access to it and is available in your region) & Open Platform for Enterprise AI (OPEA) ChatQnA Example


This demo will showcase Retrieval Augmented Generation (RAG) CPU inference using Intel® 5th Generation Xeon® Scalable processors (Emrald Rapids) featuring Intel® Trust Domain Extensions (TDX) and Intel® AMX for AI acceleration on Azure using the OPEA ChatQnA Example. For more information about OPEA, go [here](https://opea.dev/). For more information on this specific example, go [here](https://github.com/opea-project/GenAIExamples/tree/main/ChatQnA).


NOTE: If you get this error: "The property 'securityProfile.encryptionAtHost' is not valid because the 'Microsoft.Compute/EncryptionAtHost' feature is not enabled for this subscription."  -- Make sure you EncryptionAtHost is registred for your subsctiption. You can issue following AZ CLI command: az feature register --namespace Microsoft.Compute --name EncryptionAtHost


## Usage

### REQUIRED: Make necessary changes, lines 1-32 variables.tf in this example folder 

Modify the following default varabile as needed

```hcl
variable "azurerm_resource_group_name" {
  description = "Name of the resource group to be imported"
  type        = string
  default     = "ai-opea-chatqna-rg"
}

variable "region" {
  description = "Target Azure region to deploy VM in."
  type        = string
  default     = "eastus2"
}

variable "azurerm_virtual_network_name" {
  description = "Name of the preconfigured virtual network"
  type        = string
  default     = "ai-opea-chatqna-vnet1"
}

variable "virtual_network_resource_group_name" {
  description = "Name of the resource group of the virtual network"
  type        = string
  default     = "ai-opea-chatqna-rg"
}

variable "azurerm_subnet_name" {
  description = "The name of the preconfigured subnet"
  type        = string
  default     = "default"
}
```

Modify the Huggingface Token variable to your specific Huggingface Token, for information on creating a Huggingface token go [here](https://huggingface.co/docs/hub/en/security-tokens)

```hcl
variable "huggingface_token" {
  description = "Huggingface Token"
  default     = " <YOUR HUGGINGFACE TOKEN> "
  type        = string
}
```

### main.tf

Modify settings in this file to choose your source image as well as instance size and other details around the instance that will be created as needed. You may also want to modify "source_address_prefix       =" for your security group ingress rule as the defult is "*" and your firewall or security policy may block "*". All other setting should be modified in the variables.tf in this example folder

```hcl
  virtual_machine_size                = "Standard_DC32es_v5"

  source_image_reference = {
    "offer"     = "0001-com-ubuntu-confidential-vm-jammy"
    "sku"       = "22_04-lts-cvm"
    "publisher" = "Canonical"
    "version"   = "latest"
  }
   

```

Run the Terraform Commands below to deploy the demos.

```Shell
terraform init
terraform plan
terraform apply
```

## Running the Demo using Azure CloudShell

Open your Azure account and click the Cloudshell prompt
At the command prompt enter in in these command prompts to install Terraform into the Azure Cloudshell

```Shell
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
mkdir ~/bin
ln -s ~/.tfenv/bin/* ~/bin/
tfenv install 1.3.0
tfenv use 1.3.0
```

Download and run the [OPEA ChatQnA on Xeon](https://github.com/intel/terraform-intel-Azure-vm/tree/main/examples/gen-ai-xeon-opea-chatqna) Terraform Module by typing this command

```Shell
git clone https://github.com/intel/terraform-intel-azure-linux-vm.git
```

Change into the `examples/azure-gen-ai-xeon-opea-chatqna` example folder

```Shell
cd terraform-intel-azure-linux-vm/examples/azure-gen-ai-xeon-opea-chatqna
```

Run the Terraform Commands below to deploy the demos.

```Shell
terraform init
terraform plan
terraform apply
```

After the Terraform module successfully creates the Azure instance, **wait ~15 minutes** for the recipe to build and launch the containers before continuing.

## Accessing the Demo

You can access the demos using the following:

- OPEA ChatQnA: `http://yourpublicip:5174`

- Note: This module is created using the Standard_DC32es_v5 instance size, you can change your instance type by modifying the **virtual_machine_size = "Standard_DC32es_v5 "** in the main.tf under the **azurerm_linux_virtual_machine** section of the code. If you just change to an 8xlarge and then run **terraform apply** the module will destroy the old instance and rebuild with a larger instance size.

## Deleting the Demo

To delete the demo, run `terraform destroy` to delete all resources created.

## Considerations

- The Azure region where this example is run should have a default virtual network
