resource "azurerm_container_app_environment" "container_app_environment" {
  name                               = var.name
  location                           = var.location
  resource_group_name                = var.resource_group_name
  log_analytics_workspace_id         = var.log_analytics_workspace_id
  infrastructure_subnet_id           = var.infrastructure_subnet_id
  infrastructure_resource_group_name = "${var.resource_group_name}-infra"
  internal_load_balancer_enabled     = var.internal_load_balancer_enabled
  tags                               = var.tags

  dynamic "workload_profile" {
    for_each = var.workload_profiles
    content {
      name                  = workload_profile.value.name
      workload_profile_type = workload_profile.value.workload_profile_type
      maximum_count         = workload_profile.value.maximum_count
      minimum_count         = workload_profile.value.minimum_count
    }

  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}