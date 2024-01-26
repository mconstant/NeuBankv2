resource "azurerm_resource_group" "this" {
  name     = "${var.company}-${terraform.workspace}-rg-${var.region}"
  location = var.region

  tags = lookup(module.common.tags, terraform.workspace, null)
}

module "common" {
  source = "./modules/common"
}

