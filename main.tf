# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "weather-resources"
  location = "East US"
}

resource "azurerm_app_service_plan" "main" {
  name                = "weather-app"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "main" {
  name                = "weather-appservice"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.main.id

  site_config {
    windows_fx_version        = "DOTNET|5.0"
    use_32_bit_worker_process = true #This parameter is neccesary because is the "Free Tier" anything different from that is not neccesary.
                                     #https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service#use_32_bit_worker_process
  }
}