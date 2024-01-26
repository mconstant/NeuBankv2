resource "azurerm_log_analytics_workspace" "this" {
  name                = "workspace"
  location            = var.region
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "this" {
  name                = "frontend-appinsights"
  location            = var.region
  resource_group_name = var.rg_name
  workspace_id        = azurerm_log_analytics_workspace.this.id
  application_type    = "web"
}