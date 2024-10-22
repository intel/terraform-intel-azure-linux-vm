# Provision Azure VM on Intel® 4th Generation Xeon® Scalable processors (Sapphire Rapids) featuring Intel® Trust Domain Extensions (TDX) and Intel® AMX for AI acceleration on Azure Linux OS. 
# It is configured to create the VM in US-East 2 region. The region is provided in variables.tf in this example folder.
# Make sure you have an exsiting (pre-created) Azure resource group, virtual network name, virtual network rsg, subnet name - change lines 104-107 below based on your resource names
# in the local system where terraform apply is done. 
# Creates a new scurity group to open up the SSH port 22 to a specific IP CIDR block

################################################################################
# For Azure Key Vault - This section is Optional
################################################################################
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "example" {
  name                        = "aiopeanchatqnatdxjv"
  resource_group_name         = "ai-opea-chatqna-rg"
  location                    = var.region
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Delete",
      "Get",
      "Purge",
      "Recover",
      "Update",
      "GetRotationPolicy",
      "SetRotationPolicy"
    ]

    secret_permissions = [
      "Set",
    ]
    storage_permissions = [
      "Get",
    ]
  }
}

resource "azurerm_key_vault_key" "generated" {
  name         = "generated-certificate"
  key_vault_id = azurerm_key_vault.example.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }

    expire_after         = "P90D"
    notify_before_expiry = "P29D"
  }
}


######### Ansible Configuration #########
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
module "azurerm_linux_virtual_machine"  {
  #source                              = "../.."
  source                              = "intel/azure-linux-vm/intel"
  azurerm_resource_group_name         = "ai-opea-chatqna-rg"        #requried to be pre-created or modify this line based on your existing resource
  azurerm_virtual_network_name        = "ai-opea-chatqna-vnet1"     #requried to be pre-created or modify this line based on your existing resource
  virtual_network_resource_group_name = "ai-opea-chatqna-rg"        #requried to be pre-created or modify this line based on your existing resource
  azurerm_subnet_name                 = "default"                   #requried to be pre-created or modify this line based on your existing resource
  azurerm_network_interface_name      = "ai-opea-chatqna-nic01"
  vm_name                             = "ai-opea-chatqna-${random_id.rid.dec}"
  virtual_machine_size                = "Standard_DC8es_v5"
  os_disk_name                        = "ai-opea-chatqna-osdisk1"
  custom_data = data.cloudinit_config.ansible.rendered

#Set to flag below to use Intel Confidential VM with TDX
  tdx_flag                = true
  secure_boot_flag        = true
  encryption_at_host_flag = true

#Choose the images supporting Intel Confidential Compute VMs with Intel TDX
  source_image_reference = {
    "offer"     = "0001-com-ubuntu-confidential-vm-jammy"
    "sku"       = "22_04-lts-cvm"
    "publisher" = "Canonical"
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
resource "azurerm_network_security_group" "ai-opea-chatqna-nsg" {
  name                = "ai-opea-chatqna-nsg"
  location            = var.region
  resource_group_name = "ai-opea-chatqna-rg" #requried to be pre-created or modify this line based on your existing resource

  security_rule {
  name                        = "allow_ai-opea-chatqna"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["22", "80", "443", "6379", "8001", "6006", "6007", "6000", "7000", "8808", "8000", "8888", "9009", "9000",  "5173","5174"]
  #source_address_prefix       = "*"
  source_address_prefix       = "134.134.0.0/16" #required to be pre-created or modify this line based on your requirements
  destination_address_prefix  = "*"
  }

  tags = {
    Name     = "ai-opea-chatqna-${random_id.rid.dec}"
    Owner    = "owner-${random_id.rid.dec}",
    Duration = "2"
  }
}


