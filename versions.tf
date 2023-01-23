terraform {
  required_version = ">=1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.26.0"
    }
  }
}


# This block goes outside of the required_providers block!
provider "azurerm" {
  features {}
}