data "azurerm_role_definition" "role_id" {
  name = var.role_definition_name
}


resource "azurerm_role_assignment" "role_assignment" {
  scope                = var.scope_id # You can replace this with the appropriate scope if needed
  role_definition_name = var.role_definition_name
  principal_id         = var.principal_id
  principal_type       = var.principal_type

  lifecycle {
    ignore_changes = [
      principal_type
    ]
  }
}
