# Provision VM on Icelake on Azure Linux OS in default vpc. It is configured to create the VM in
# US-East region. The region is provided in variables.tf in this example folder.

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
  azurerm_subnet_name                 = "default"
  azurerm_network_interface_name      = "redhat8-nic01"
  vm_name                             = "ai-opea-chatqna-${random_id.rid.dec}"
  virtual_machine_size                = "Standard_D32s_v5"
  os_disk_name                        = "value"
  custom_data = data.cloudinit_config.ansible.rendered
  source_image_reference = {
    "offer"     = "RHEL"
    "sku"       = "8-LVM-gen2"
    "publisher" = "RedHat"
    "version"   = "latest"
  }
  admin_password                       = var.admin_password
  tags = {
    Name     = "ai-opea-chatqna-${random_id.rid.dec}"
    Owner    = "owner-${random_id.rid.dec}",
    Duration = "2"
  }
}

# Modify the `ingress_rules` variable in the variables.tf file to allow the required ports for your CIDR ranges
resource "azurerm_network_security_group" "allow_ai-opea-chatqna-nsg" {
  name                = "allow_ai-opea-chatqna-nsg"
  location            = var.region
  resource_group_name = "ai-opea-chatqna-rg"

  security_rule {
  name                        = "allow_ai-opea-chatqna"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["22", "80", "443", "6379", "8001", "6006", "6007", "6000", "7000", "8808", "8000", "8888", "9009", "9000",  "5173","5174"]
  #source_address_prefix       = "*"
  source_address_prefix       = "134.134.0.0/16"
  destination_address_prefix  = "*"
  }

  tags = {
    environment = "test"
  }
}

