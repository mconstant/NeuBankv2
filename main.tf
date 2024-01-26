resource "azurerm_resource_group" "this" {
  count    = var.enable ? 1 : 0
  name     = "${var.company}-${terraform.workspace}-rg-${var.region}"
  location = var.region

  tags = lookup(module.common.tags, terraform.workspace, null)
}

module "network" {
  count  = var.enable ? 1 : 0
  source = "./modules/network"

  company = var.company
  region  = var.region
  rg_name = azurerm_resource_group.this[0].name
}

module "common" {
  source = "./modules/common"
}

