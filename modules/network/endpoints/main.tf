resource "azurerm_private_endpoint" "backend" {
  name                = "backwebappprivateendpoint"
  location            = var.region
  resource_group_name = var.rg_name
  subnet_id           = var.endpoint_subnet_id

  private_dns_zone_group {
    name                 = "privatednszonegroup"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }

  private_service_connection {
    name                           = "privateendpointconnection"
    private_connection_resource_id = var.backend_id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  tags = lookup(module.common.tags, terraform.workspace, null)
}

module "common" {
  source = "../../common"
}