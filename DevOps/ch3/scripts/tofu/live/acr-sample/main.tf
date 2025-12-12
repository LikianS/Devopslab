provider "azurerm" {
  features {}
  subscription_id = "c838020d-4f6b-4ff9-9984-1a05909d3f36"
}

# --- CORRECTION ICI : On utilise "data" et pas "resource" ---
# Cela permet de récupérer les infos du groupe créé précédemment sans essayer de le recréer
data "azurerm_resource_group" "rg" {
  name = "aks-resource-group"
}

resource "azurerm_container_registry" "acr" {
  # ATTENTION : Changez "Unique123" par votre pseudo (ex: likian) sinon ça plantera
  # Le nom doit être unique dans tout Azure, minuscule, sans tiret.
  name                = "sampleappregistrylikian" 
  
  # On récupère les infos depuis le "data" défini au-dessus
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  
  sku                 = "Basic"
  admin_enabled       = true
}

output "login_server" {
  value = azurerm_container_registry.acr.login_server
}
