resource "random_pet" "db" {
  length = 1
}

resource "random_password" "password" {
  length      = 20
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  special     = true
}

resource "azurerm_network_security_group" "db" {
  name                = "${var.company}-${terraform.workspace}-${random_pet.db.id}-nsg-${var.region}"
  location            = var.region
  resource_group_name = var.rg_name

  tags = lookup(module.common.tags, terraform.workspace, null)
}

resource "azurerm_subnet" "db" {
  name                 = "${var.company}-${terraform.workspace}-${random_pet.db.id}-db-subnet-${var.region}"
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["10.0.3.0/28"]

  delegation {
    name = "managedinstancedelegation"

    service_delegation {
      name = "Microsoft.Sql/managedInstances"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

# Associate subnet and the security group
resource "azurerm_subnet_network_security_group_association" "db" {
  subnet_id                 = azurerm_subnet.db.id
  network_security_group_id = azurerm_network_security_group.db.id
}

# Create a route table
resource "azurerm_route_table" "db" {
  name                          = "${var.company}-${terraform.workspace}-${random_pet.db.id}-rt-${var.region}"
  location                      = var.region
  resource_group_name           = var.rg_name
  disable_bgp_route_propagation = false
}

# Associate subnet and the route table
resource "azurerm_subnet_route_table_association" "db" {
  subnet_id      = azurerm_subnet.db.id
  route_table_id = azurerm_route_table.db.id

  depends_on = [azurerm_subnet_network_security_group_association.db]
}

# Create managed instance
resource "azurerm_mssql_managed_instance" "db" {
  name                         = "${var.company}-${terraform.workspace}-managedmssql-${var.region}"
  resource_group_name          = var.rg_name
  location                     = var.region
  subnet_id                    = azurerm_subnet.db.id
  administrator_login          = "${replace(random_pet.db.id, "-", "")}admin"
  administrator_login_password = random_password.password.result
  license_type                 = var.db_license_type
  sku_name                     = var.db_sku_name
  vcores                       = var.db_vcores
  storage_size_in_gb           = var.db_storage_size_in_gb

  tags = lookup(module.common.tags, terraform.workspace, null)

  depends_on = [azurerm_subnet_route_table_association.db]
}

module "common" {
  source = "../common"
}