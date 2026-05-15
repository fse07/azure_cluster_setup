locals {
  cluster_name = "aks-${var.project_name}-${var.environment}"
  vnet_name    = "vnet-${var.project_name}-${var.environment}"
  acr_name     = replace("acr${var.project_name}${var.environment}", "-", "")
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}
