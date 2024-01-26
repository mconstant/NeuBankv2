resource "azurerm_resource_group" "this" {
  count    = var.enable ? 1 : 0
  name     = "${var.company}-${terraform.workspace}-rg-${var.region}"
  location = var.region

  tags = lookup(module.common.tags, terraform.workspace, null)
}

module "network" {
  count  = var.enable ? 1 : 0
  source = "./modules/network"

  company     = var.company
  region      = var.region
  rg_name     = azurerm_resource_group.this[0].name
  frontend_id = module.app_stack[0].frontend_id
  backend_id  = module.app_stack[0].backend_id
}

module "app_stack" {
  count  = var.enable ? 1 : 0
  source = "./modules/app_stack"

  company                          = var.company
  region                           = var.region
  rg_name                          = azurerm_resource_group.this[0].name
  app_insights_connection_string   = module.app_insights[0].connection_string
  app_insights_instrumentation_key = module.app_insights[0].instrumentation_key
}

module "db" {
  count  = var.enable ? 1 : 0
  source = "./modules/db"

  company   = var.company
  region    = var.region
  rg_name   = azurerm_resource_group.this[0].name
  vnet_name = module.network[0].vnet_name
}

module "storage" {
  count  = var.enable ? 1 : 0
  source = "./modules/storage"

  company            = var.company
  region             = var.region
  rg_name            = azurerm_resource_group.this[0].name
  endpoint_subnet_id = module.network[0].endpoint_subnet_id
}

module "app_insights" {
  count  = var.enable ? 1 : 0
  source = "./modules/app_insights"

  company = var.company
  region  = var.region
  rg_name = azurerm_resource_group.this[0].name
}

module "common" {
  source = "./modules/common"
}

