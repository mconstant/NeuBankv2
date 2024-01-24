resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = local.location

  tags = lookup(module.common.tags, terraform.workspace, null)
}

