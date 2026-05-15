resource "azurerm_user_assigned_identity" "aks" {
  name                = "id-${var.project_name}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags
}

resource "azurerm_role_assignment" "network_contributor" {
  scope                = azurerm_virtual_network.main.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id

  depends_on = [azurerm_user_assigned_identity.aks]
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id

  depends_on = [azurerm_user_assigned_identity.aks, azurerm_container_registry.main]
}

resource "azurerm_role_assignment" "managed_identity_operator" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id

  depends_on = [azurerm_user_assigned_identity.aks]
}

resource "azurerm_role_assignment" "vm_contributor" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id

  depends_on = [azurerm_user_assigned_identity.aks]
}
