provider "azurerm" {
  features {}
  subscription_id = "c838020d-4f6b-4ff9-9984-1a05909d3f36"
}

resource "azurerm_resource_group" "aks_rg" {
  name     = "aks-resource-group"
  location = "francecentral"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-sample"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "aks-sample"

  default_node_pool {
    name       = "default"
    node_count = 2             # Équivalent de desired_worker_nodes
    vm_size    = "Standard_B2s" # Équivalent approximatif du t2.micro (attention aux quotas)
  }

  identity {
    type = "SystemAssigned"
  }
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "resource_group_name" {
  value = azurerm_resource_group.aks_rg.name
}
