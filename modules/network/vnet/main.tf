resource "azurerm_virtual_network" "this" {
  name                = "${var.company}-${terraform.workspace}-vnet-${var.region}"
  location            = var.region
  resource_group_name = var.rg_name
  address_space       = ["10.0.0.0/16"]

  tags = lookup(module.common.tags, terraform.workspace, null)
}

module "common" {
  source = "../../common"
}