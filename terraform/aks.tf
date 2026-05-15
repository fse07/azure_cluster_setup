resource "azurerm_kubernetes_cluster" "main" {
  name                = local.cluster_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "${var.project_name}-${var.environment}"
  kubernetes_version  = var.kubernetes_version
  tags                = var.tags

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  default_node_pool {
    name                = "systempool"
    node_count          = var.system_node_count
    vm_size             = var.system_node_vm_size
    os_disk_size_gb     = 50
    os_disk_type        = "Managed"
    max_pods            = 30
    zones               = ["2"]
    vnet_subnet_id      = azurerm_subnet.aks.id

    node_labels = {
      "role" = "system"
    }

    only_critical_addons_enabled = true
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "cilium"
    network_data_plane   = "cilium"
    pod_cidr            = "10.244.0.0/16"
    service_cidr        = "10.0.2.0/24"
    dns_service_ip      = "10.0.2.10"
    load_balancer_sku   = "standard"
    outbound_type       = "loadBalancer"
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  linux_profile {
    admin_username = "azureuser"
    ssh_key {
      key_data = var.ssh_public_key
    }
  }

  depends_on = [
    azurerm_role_assignment.network_contributor,
    azurerm_role_assignment.managed_identity_operator,
    azurerm_role_assignment.vm_contributor
  ]
}

resource "azurerm_kubernetes_cluster_node_pool" "ebpf" {
  name                  = "ebpfpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = var.ebpf_node_vm_size
  node_count            = var.ebpf_node_count
  os_disk_size_gb       = 100
  os_disk_type          = "Managed"
  max_pods              = 50
  zones                 = ["2", "3"]
  vnet_subnet_id        = azurerm_subnet.aks.id
  enable_node_public_ip = false

  node_labels = {
    "role"     = "ebpf-worker"
    "workload" = "turn-relay"
  }

  node_taints = [
    "workload=ebpf:NoSchedule"
  ]

  tags = var.tags
}
