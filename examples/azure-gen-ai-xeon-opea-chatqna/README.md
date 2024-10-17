<p align="center">
  <img src="https://github.com/intel/terraform-intel-Azure-vm/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel® Optimized Cloud Modules for Terraform

© Copyright 2024, Intel Corporation

## Azure Standard_D32s_v5 Instance with 3rd Generation Intel® Xeon® Scalable Processor (Ice Lake) & Open Platform for Enterprise AI (OPEA) ChatQnA Example

This demo will showcase Retrieval Augmented Generation (RAG) CPU inference using 3rd Generation Intel® Xeon® Scalable Processor on Azure using the OPEA ChatQnA Example. For more information about OPEA, go [here](https://opea.dev/). For more information on this specific example, go [here](https://github.com/opea-project/GenAIExamples/tree/main/ChatQnA).

## Usage

### variables.tf

Modify the region to target a specific Azure Region

```hcl
variable "region" {
  description = "Target Azure region to deploy VM in."
  type        = string
  default     = "eastus"
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

Modify settings in this file to choose your source image as well as instance size and other details around the instance that will be created

```hcl
  virtual_machine_size                = "Standard_D32s_v5"
  source_image_reference = {
    "offer"     = "RHEL"
    "sku"       = "8-LVM-gen2"
    "publisher" = "RedHat"
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
git clone https://github.com/intel/terraform-intel-Azure-vm.git
```

Change into the `examples/gen-ai-xeon-opea-chatqna` example folder

```Shell
cd terraform-intel-Azure-vm/examples/gen-ai-xeon-opea-chatqna
```

Run the Terraform Commands below to deploy the demos.

```Shell
terraform init
terraform plan
terraform apply
```

After the Terraform module successfully creates the EC2 instance, **wait ~15 minutes** for the recipe to build and launch the containers before continuing.

## Accessing the Demo

You can access the demos using the following:

- OPEA ChatQnA: `http://yourpublicip:5174`

- Note: This module is created using the m7i.16xlarge instance size, you can change your instance type by modifying the **instance_type = "m7i.16xlarge"** in the main.tf under the **ec2-vm module** section of the code. If you just change to an 8xlarge and then run **terraform apply** the module will destroy the old instance and rebuild with a larger instance size.

## Deleting the Demo

To delete the demo, run `terraform destroy` to delete all resources created.

## Considerations

- The Azure region where this example is run should have a default VPC
