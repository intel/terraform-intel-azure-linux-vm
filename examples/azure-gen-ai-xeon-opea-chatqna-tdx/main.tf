# Provisions Azure VM on Intel® 5th Generation Xeon® Scalable processors (Emerald Rapids) featuring Intel® Trust Domain Extensions (TDX) and Intel® AMX for AI acceleration on Azure Linux OS. 
# It is configured to create the VM in US-East region. The region is provided in variables.tf in this example folder.
# Make sure you have an existing (pre-created) Azure resource group, virtual network, and subnet in your subscription- see variable.tf to make necessary changes, lines 1-32 
# in the local system where terraform apply is done. Also make sure you subscription has access to public preview for the DCv6 Azure Instances in the region where your resource group is in
# Creates a new security group required for ChatQNA from ANY source 

################################################################################
# For Azure Key Vault - This section is Optional
################################################################################
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "example" {
  name                        = var.azurerm_key_vault
  resource_group_name         = var.azurerm_resource_group_name
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
  name         = var.azurazurerm_key_vault_key
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
        HUGGINGFACEHUB_API_TOKEN = var.huggingface_token
      }
    )
  }
}

#Random ID to minimize the chances of name conflicts
resource "random_id" "rid" {
  byte_length = 5
}
#Create public IP using public ip resource
data "azurerm_subnet" "subnet" {
  name                 = var.azurerm_subnet_name
  virtual_network_name = var.azurerm_virtual_network_name
  resource_group_name  = var.azurerm_resource_group_name
}

resource "azurerm_public_ip" "public_ip" {
  name                = var.azurerm_public_ip_name
  location            = var.region
  resource_group_name = var.azurerm_resource_group_name
  allocation_method   = "Dynamic" # or "Static"
}

# Modify the `vm_count` variable in the variables.tf file to create the required number of Azure VMs 
module "azurerm_linux_virtual_machine" {
  #source = "../.."
  source                              = "intel/azure-linux-vm/intel"
  version                             = "v2.0.5"
  azurerm_resource_group_name         = var.azurerm_resource_group_name
  azurerm_virtual_network_name        = var.azurerm_virtual_network_name
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  azurerm_subnet_name                 = var.azurerm_subnet_name
  azurerm_network_interface_name      = var.azurerm_network_interface_name


  ip_configuration_public_ip_address_id = azurerm_public_ip.public_ip.id

  vm_name              = "ai-opea-chatqna-${random_id.rid.dec}"
  virtual_machine_size = "Standard_DC64es_v6" 
  os_disk_name         = var.os_disk_name
  disk_size_gb         = 500
  custom_data          = data.cloudinit_config.ansible.rendered

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

  admin_password = var.admin_password

  tags = {
    Name     = "ai-opea-chatqna-${random_id.rid.dec}"
    Owner    = "owner-${random_id.rid.dec}",
    Duration = "2"
  }
}

# Modify the `ingress_rules` variable in the variables.tf file to allow the required ports for your CIDR ranges
resource "azurerm_network_security_group" "ai-opea-chatqna-nsg" {
  name                = var.azurerm_network_security_group_name
  location            = var.region
  resource_group_name = var.azurerm_resource_group_name

  security_rule {
    name                       = "allow_ai-opea-chatqna"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "80", "443", "6379", "8001", "6006", "6007", "6000", "7000", "8808", "8000", "8888", "9009", "9000", "5173", "5174"]
    source_address_prefix      = var.source_address_prefix
    destination_address_prefix = "*"
  }

  tags = {
    Name     = "ai-opea-chatqna-${random_id.rid.dec}"
    Owner    = "owner-${random_id.rid.dec}",
    Duration = "2"
  }
}


