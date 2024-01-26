output "administrator_login_password" {
  value     = azurerm_mssql_managed_instance.db.administrator_login_password
  sensitive = true
}