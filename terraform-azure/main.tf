# Configure the Azure provider. This is not needed...
terraform {
  required_providers {
    azure = {
      source  = "hashicorp/azurerm"
      version = "2.25.0"
    }
  }
}

provider "azurerm" {
  version = "=2.25.0"
  features {}
}

resource "azurerm_resource_group" "camelk-demo" {
  name     = "camelk-demo-resources"
  location = "East US"
}

resource "azurerm_container_registry" "camelk-demo" {
  name                     = "CamelkDemoContainerRegistry"
  resource_group_name      = azurerm_resource_group.camelk-demo.name
  location                 = azurerm_resource_group.camelk-demo.location
  sku                      = "Basic"
  admin_enabled            = false
}

resource "azurerm_kubernetes_cluster" "camelk-demo" {
  name                = "camelk-demo-aks"
  location            = azurerm_resource_group.camelk-demo.location
  resource_group_name = azurerm_resource_group.camelk-demo.name
  dns_prefix          = "camelk-demo-aks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  addon_profile {
    aci_connector_linux {
      enabled = false
    }

    azure_policy {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    kube_dashboard {
      enabled = true
    }

    oms_agent {
      enabled = false
    }
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.camelk-demo.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.camelk-demo.kube_config_raw
}

output "client_key" {
  value = azurerm_kubernetes_cluster.camelk-demo.kube_config.0.client_key
}