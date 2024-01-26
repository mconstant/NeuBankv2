resource "azurerm_subnet" "endpoint" {
  name                                      = "${var.company}-${terraform.workspace}-endpoint-subnet-${var.region}"
  resource_group_name                       = var.rg_name
  virtual_network_name                      = var.virtual_network_name
  address_prefixes                          = ["10.0.2.0/24"]
  private_endpoint_network_policies_enabled = true
  service_endpoints                         = ["Microsoft.Storage"]
}

resource "azurerm_subnet" "integration" {
  name                 = "${var.company}-${terraform.workspace}-integration-subnet-${var.region}"
  resource_group_name  = var.rg_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.0.1.0/24"]
  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}