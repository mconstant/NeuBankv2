resource "random_string" "sac" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_storage_account" "blob" {
  name                            = "${random_string.sac.result}${terraform.workspace}storacc${var.region}"
  resource_group_name             = var.rg_name
  location                        = var.region
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false

  sas_policy {
    expiration_period = "90.00:00:00"
    expiration_action = "Log"
  }

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }


  tags = lookup(module.common.tags, terraform.workspace, null)
}

resource "azurerm_private_endpoint" "blob" {
  name                = "${var.company}-${terraform.workspace}-stendpt-${var.region}"
  location            = var.region
  resource_group_name = var.rg_name
  subnet_id           = var.endpoint_subnet_id
  private_service_connection {
    name                           = "example_psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.blob.id
    subresource_names              = ["blob"]
  }
}

resource "azurerm_storage_container" "blob" {
  name                  = "${var.company}-${terraform.workspace}-sc-${var.region}"
  storage_account_name  = azurerm_storage_account.blob.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "blob" {
  name                   = "rr123.gif"
  storage_account_name   = azurerm_storage_account.blob.name
  storage_container_name = azurerm_storage_container.blob.name
  type                   = "Block"
}

module "common" {
  source = "../common"
}