provider "azurerm" {
  features {}

  subscription_id = "25a98a18-5e94-4b21-9d17-e8cf45bfd81f"
  client_id       = "e6a77e66-4d67-43e4-8983-34598241c329"
  client_secret   = "Fc3Ci8pZpOlJYmL5tT7HUTCj-pNokJWGxM"
  tenant_id       = "558506eb-9459-4ef3-b920-ad55c555e729"
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.56.0"
    }
  }
   backend "remote" {
    organization = "zm-intern06"

    workspaces {
      name = "Pipeline_AZ"
    }
  }
}
resource "azurerm_resource_group" "rg" {
  name     = "resources_contain"
  location = "West Europe"
}

resource "azurerm_container_registry" "acr" {
  name                     = "myfirstcontainer"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Premium"
  admin_enabled            = false
  georeplication_locations = ["East US", "West Europe"]
}