provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "capstone-rg"
  location = "centralus"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "capstone-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "k8s"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_Ds2"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  role_based_access_control {
    enabled = true
  }

  tags = {
    environment = "Production"
  }
}