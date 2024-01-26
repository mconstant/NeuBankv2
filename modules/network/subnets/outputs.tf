output "endpoint_subnet_id" {
  value = azurerm_subnet.endpoint.id
}

output "integration_subnet_id" {
  value = azurerm_subnet.integration.id
}