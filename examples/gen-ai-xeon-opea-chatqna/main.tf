# Provision VM on Icelake on Azure Linux OS in default vpc. It is configured to create the VM in
# US-East region. The region is provided in variables.tf in this example folder.

# This example also create an VM key pair. Associate the public key with the VM. Create the private key
# in the local system where terraform apply is done. Create a new scurity group to open up the SSH port 
# 22 to a specific IP CIDR block

######### PLEASE NOTE TO CHANGE THE IP CIDR BLOCK TO ALLOW SSH FROM YOUR OWN ALLOWED IP ADDRESS FOR SSH #########

data "cloudinit_config" "ansible" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "cloud_init"
    content_type = "text/cloud-config"
    content = templatefile(
      "cloud_init.yml", 
      {
        HUGGINGFACEHUB_API_TOKEN=var.huggingface_token
      }
    )
  }
}

#Random ID to minimize the chances of name conflicts
resource "random_id" "rid" {
  byte_length = 5
}

# Modify the `vm_count` variable in the variables.tf file to create the required number of Azure VMs 
module "azurerm_linux_virtual_machine" {
  #source                              = "../.."
  source                              = "intel/azure-linux-vm/intel"
  azurerm_resource_group_name         = "ai-opea-chatqna-rg"
  azurerm_virtual_network_name        = "ai-opea-chatqna-vnet1"
  virtual_network_resource_group_name = "ai-opea-chatqna-rg"
  vm_name                             = "ai-opea-chatqna-${random_id.rid.dec}"
  virtual_machine_size                = "Standard_D32s_v5"
  os_disk_name                        = "value"
  azurerm_network_interface_name      = "redhat8-nic01"
  azurerm_subnet_name                 = "default"
  admin_password                      = var.admin_password
  source_image_reference = {
    "offer"     = "RHEL"
    "sku"       = "8-LVM-gen2"
    "publisher" = "RedHat"
    "version"   = "latest"
  }

  tags = {
    Name     = "ai-opea-chatqna-${count.index}-${random_id.rid.dec}"
    Owner    = "owner-${random_id.rid.dec}",
    Duration = "2"
  }
}

resource "azurerm_resource_group" "ai-opea-chatqna" {
  name     = "ai-opea-chatqna-rg"
  location = "East US"
}

resource "azurerm_network_security_group" "ai-opea-chatqna" {
  name                = "ai-opea-chatqna-sg"
  location            = azurerm_resource_group.ai-opea-chatqna.location
  resource_group_name = azurerm_resource_group.ai-opea-chatqna.name

  security_rule {
    name                       = "ai-opea-chatqna-ingressrule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = var.ingress_rules[count.index].protocol
    source_port_range          = var.ingress_rules[count.index].from_port
    destination_port_range     = var.ingress_rules[count.index].to_port
    #source_address_prefix     = "*"
    source_address_prefix      = [var.ingress_rules[count.index].cidr_blocks]
    destination_address_prefix = "*"
  }

  tags = {
    Name     = "ai-opea-chatqna-${count.index}-${random_id.rid.dec}"
    Owner    = "owner-${random_id.rid.dec}",
    Duration = "2"
  }
}

