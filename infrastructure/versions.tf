terraform {
  required_version = "~> 1.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.14"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "projecttfstate"
    container_name       = "tfstate"
    key                  = "project-agent/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
