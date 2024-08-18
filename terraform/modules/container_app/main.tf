resource "azurerm_container_app" "this" {
  name                         = var.name_prefix
  container_app_environment_id = var.container_app_environment_id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"
  workload_profile_name        = "Consumption"

  template {
    container {
      name   = var.container_name
      image  = "${var.container_registry_url}/${var.image}"
      cpu    = 0.25
      memory = "0.5Gi"

      dynamic "env" {
        for_each = var.env_vars
        content {
          name  = env.key
          value = env.value
        }
      }
    }

    min_replicas = var.min_replicas
    max_replicas = var.max_replicas
  }

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [var.principal_id]
  }

  registry {
    identity = var.principal_id
    server   = var.container_registry_url
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = var.target_port

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = var.tags
}





