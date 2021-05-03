provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
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
  name                     = var.registry_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Premium"
  admin_enabled            = false
  georeplication_locations = ["East US", "West Europe"]
}


resource "azurerm_resource_group" "arg" {
  name     = "instin_resources"
  location = "West Europe"
}


resource "azurerm_container_group" "exemp" {
  name                = var.instance_name
  location            = azurerm_resource_group.arg.location
  resource_group_name = azurerm_resource_group.arg.name
  ip_address_type     = "public"
  dns_name_label      = "aci-label"
  os_type             = "Linux"

  container {
    name   = "hello-world"
    image  = "microsoft/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 443
      protocol = "TCP"
    }
  }

  container {
    name   = "sidecar"
    image  = "microsoft/aci-tutorial-sidecar"
    cpu    = "0.5"
    memory = "1.5"
  }

  tags = {
    environment = "testing"
  }
}
