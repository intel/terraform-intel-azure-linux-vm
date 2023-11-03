
<p align="center">
   <img src="https://github.com/intel/terraform-intel-azure-linux-vm/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel® Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Terraform Intel Azure VM - DC_Sv3 Instance with 3rd Generation Intel® Xeon® Scalable Processor (Ice Lake) & Intel® Cloud Optimized Recipe for SGX & Gramine 

This demo will showcase an Pytorch Application Example running in SGX - Enabled Enclave using Gramine 

This example creates Azure virtual machine on Intel Icelake CPU on Linux Operating System. The virtual machine is created on an Intel Icelake Standard_DCs_v3

SGX-enabled Azure VMs: At Azure, VMs of the DCsv3 and DCdsv3-series should be used. Azure provides a quickstart guide to setup such VMs. During the selection of the VM, one has to carefully select a machine providing the necessary amount of EPC memory suiting the application. A table with the provided EPC memory size can be found on the DCsv3 and DCdsv3-series overview.


As you configure your application's environment, choose the configurations for your infrastructure that matches your application's requirements.

In this example, the virtual machine is using a preconfigured network interface, subnet, and resource group. The tags Name, Owner and Duration are added to the virtual machine when it is created.

## Usage

**See examples folder for code ./examples/azure-linux-vm-sgx-gramine-recipe/main.tf**

variables.tf
```hcl
variable "admin_password" {
  description = "The Password which should be used for the local-administrator on this virtual machine"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.admin_password) >= 8
    error_message = "The admin_password value must be at least 8 characters in length"
  }
}
```

### main.tf

Modify settings in this file to choose your instance type and instance size and other details around the instance that will be created

*NOTE: Instance type has to be SGX-Capable Host to run the Recipe*


```hcl
#This example deploys a SGX-Capable Azure Virtual Machine (DCs_v3 series)

#Cloud-init is a commonly-used startup configuration utility for cloud compute instances to run the ansible playbook
data "cloudinit_config" "ansible" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "cloud_init.yml"
    content_type = "text/cloud-config"
    content = templatefile(
      "cloud_init.yml",
      {}
    )
  }
}

/* You can verify that the Ansible playbook was deployed successfully by checking the logs on the virtual machine:

ssh azureuser@<vm_ip_address>
tail -f /var/log/ansible/ansible.log
If the Ansible playbook was deployed successfully, you will see a message in the logs indicating that the playbook completed successfully. */


module "azurerm_linux_virtual_machine" {
  source                              = "intel/azure-linux-vm/intel"
  azurerm_resource_group_name         = "terraform-testing-rg"
  azurerm_virtual_network_name        = "virtualNetwork1"
  virtual_network_resource_group_name = "terraform-testing-rg"
  azurerm_subnet_name                 = "subnet1"
  admin_password                      = var.admin_password

  #SGX-Capable Host
  vm_name                               = "sgx-demo-recipe-test"
  virtual_machine_size                  = "Standard_DC8s_v3"
  ip_configuration_public_ip_address_id = "/subscriptions/d4ab7583-eee6-45fe-9487-a7a0b59a389a/resourceGroups/terraform-testing-rg/providers/Microsoft.Network/publicIPAddresses/terraform-testing-public-ip"

  #Calling the SGX-Gramine Recipe avaliable here : https://github.com/intel/optimized-cloud-recipes/tree/main/recipes/ai-pytorch-sgx-ubuntu
  custom_data                            = data.cloudinit_config.ansible.rendered

  source_image_reference_offer          = "0001-com-ubuntu-server-focal"
  source_image_reference_publisher      = "Canonical"
  source_image_reference_sku            = "20_04-lts-gen2"
  source_image_reference_version        = "latest"

  tags = {
    "owner"    = "example@company.com"
    "duration" = "1"
  }
}

```

Run the Terraform Commands below to deploy the demos.

```Shell
terraform init
terraform plan
terraform apply
```
## Running the Demo Example
### Intel® Confidential Compute for PyTorch

In the following two sections, we explain how a Docker image for a Gramine-protected PyTorch version
can be built and how the image can be executed. All the  [prerequisites](https://github.com/gramineproject/contrib/blob/master/Intel-Confidential-Compute-for-X/README.md#prerequisites)
for the Intel Confidential Compute for X are met - if you you have used the Intel Optimized Cloud Recipes for SGX


### Build a Gramine-protected PyTorch image

Perform the following steps on your system:

1. Clone the Gramine Contrib repository:
   ```sh
   git clone --depth 1 https://github.com/gramineproject/contrib.git
   ```

2. Move to the Intel® Confidential Compute for X folder:
   ```sh
   sudo su #Become the root user
   cd contrib/Intel-Confidential-Compute-for-X
   ```

3. Perform one of the following alternatives.  Note that both alternatives assume that the user has
   build a Docker base image (`<base_image_with_pytorch>`) containing PyTorch and the necessary
   files.

   - **Option 1**: To generate a Gramine-protected, pre-configured, non-production ready, test image for PyTorch,
     perform the following steps:

     1. Install the [prerequisites](https://github.com/gramineproject/contrib/blob/master/Intel-Confidential-Compute-for-X/workloads/pytorch/base_image_helper/README.md#prerequisites) for this workload.

     2. Use the prepared helper script (`base_image_helper/helper.sh`) to generate a base PyTorch Docker Image
        image containing an encrypted model and an encrypted sample picture:
        ```sh
        /bin/bash workloads/pytorch/base_image_helper/helper.sh
        ```
        The resulting Docker image is called `pytorch-encrypted`.

     3. Generate Gramine-protected, pre-configured, non-production ready, test image for PyTorch,
        which is based on the just generated `pytorch-encrypted` image:
        ```sh
        python3 ./curate.py pytorch pytorch-encrypted --test
        ```
          The resulting SGX-Enabled Gramine Docker image is called `gsc-pytorch-encrypted`.

   - **Option 2**: To generate a Gramine-protected, pre-configured PyTorch image based on a **user-provided** PyTorch
     Docker image, execute the following to launch an interactive setup script:
     ```sh
     python3 ./curate.py pytorch <base_image_with_pytorch>
     ```


### Execute Gramine-protected PyTorch image

Follow the output of the image build script `curate.py` to run the generated Docker image.

Run the Gramine generated PyTorch image using below command:

```sh
docker run --net=host --device=/dev/sgx/enclave -it gsc-pytorch-encrypted
```

Note that validation was only done on a Standard_DC8s_v3 Azure VM.


### Retrieve and decrypt the results

The encrypted results of the execution are generated in `/workspace/result.txt` within the
container. You need to copy the results from the container to your local machine and decrypt the
results using the following commands:
```sh
docker cp <container id or name>:/workspace/result.txt .
gramine-sgx-pf-crypt decrypt -w encryption_key -i result.txt -o result_plaintext.txt
```

Make sure that the path to your `encryption_key` is correct.


### Contents

This directory contains the following artifacts, which help to create a Gramine-protected PyTorch
image:

    .
    |-- pytorch-gsc.dockerfile.template   # Template used by `curation_script.sh` to create a
    |                                       wrapper dockerfile `pytorch-gsc.dockerfile` that
    |                                       includes user-provided inputs, e.g., `ca.cert` file etc.
    |                                       into the graminized PyTorch image.
    |-- pytorch.manifest.template         # Template used by `curation_script.sh` to create a
    |                                       user manifest file (with basic set of values defined
    |                                       for graminizing PyTorch images) that will be passed to
    |                                       GSC.
    |-- base_image_helper/                # Directory contains artifacts that help to generate a
    |                                       base image containing an encrypted model and an
    |                                       encrypted sample picture.


## Deleting the Demo
Note that this example may create resources. Run `terraform destroy` when you don't need these resources anymore.

## Considerations  

```hcl
When admin_password is specified disable_password_authentication must be set to false

Either admin_password or admin_ssh_key must be specified

Only Managed Disks are supported via this separate resource, Unmanaged Disks can be attached using the storage_data_disk block in the azurerm_virtual_machine resource.

```
## Links
[Intel® Software Guar Extensions (SGX)](https://www.intel.com/content/www/us/en/products/docs/accelerator-engines/advanced-matrix-extensions/overview.html)

[Gramine](https://github.com/gramineproject)

[Intel-Confidential-Compute-for-X](https://github.com/gramineproject/contrib/tree/master/Intel-Confidential-Compute-for-X)

[Intel® OpenAPI Base Toolkit](https://www.intel.com/content/www/us/en/developer/tools/oneapi/base-toolkit.html#gs.3tswe8)

[Intel® OpenAPI AI Analytics Toolkit](https://www.intel.com/content/www/us/en/developer/tools/oneapi/ai-analytics-toolkit.html#gs.3tsgs4)