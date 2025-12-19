terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.51.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rgtest1"
    storage_account_name = "stg31211212"
    container_name       = "stgcont1"
    key                  = "stg.tfstate"
  }
}
provider "azurerm" {
  features {}
  subscription_id = "6b085240-a951-404c-8e9c-110ec63f18de"
}

