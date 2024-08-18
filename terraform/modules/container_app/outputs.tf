output "principal_id" {
  value = azurerm_container_app.this.identity.0.principal_id
}