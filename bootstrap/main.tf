locals {
  resource_group_name    = "${var.github_user_name}-${var.github_repository}-${random_integer.sa_num.result}"
  storage_account_name   = "${lower(var.github_user_name)}${lower(var.github_repository)}${random_integer.sa_num.result}"
  sas_account_name       = "${lower(var.github_user_name)}${lower(var.github_repository)}${random_integer.sa_num.result}sas"
  service_principal_name = "${var.github_user_name}-${var.github_repository}-${random_integer.sa_num.result}"
}

data "azurerm_subscription" "current" {}

data "azuread_client_config" "current" {}

resource "azuread_application" "gh_actions" {
  display_name = local.service_principal_name
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "gh_actions" {
  client_id = azuread_application.gh_actions.application_id
  owners    = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "gh_actions" {
  service_principal_id = azuread_service_principal.gh_actions.object_id
}

resource "azurerm_role_assignment" "gh_actions" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.gh_actions.id
}

# Azure Storage Account

resource "random_integer" "sa_num" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "setup" {
  name     = local.resource_group_name
  location = var.azure_location
}

resource "azurerm_storage_account" "sa" {
  name                          = local.storage_account_name
  resource_group_name           = azurerm_resource_group.setup.name
  location                      = var.azure_location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  # public_network_access_enabled = false
}

data "azurerm_storage_account_sas" "sas" {
  connection_string = azurerm_storage_account.sa.primary_connection_string
  https_only        = true

  resource_types {
    service   = true
    container = false
    object    = false
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = "2018-03-21T00:00:00Z"
  expiry = "2025-03-21T00:00:00Z"

  permissions {
    read    = true
    write   = true
    delete  = true
    list    = true
    add     = true
    create  = true
    update  = true
    process = true
    tag     = true
    filter  = true
  }
}

resource "azurerm_storage_container" "ct" {
  name                 = "terraform-state"
  storage_account_name = azurerm_storage_account.sa.name
}

## GitHub secrets

resource "github_actions_secret" "actions_secret" {
  for_each = {
    STORAGE_ACCOUNT     = azurerm_storage_account.sa.name
    RESOURCE_GROUP      = azurerm_storage_account.sa.resource_group_name
    CONTAINER_NAME      = azurerm_storage_container.ct.name
    ARM_CLIENT_ID       = azuread_service_principal.gh_actions.application_id
    ARM_CLIENT_SECRET   = azuread_service_principal_password.gh_actions.value
    ARM_SUBSCRIPTION_ID = data.azurerm_subscription.current.subscription_id
    ARM_TENANT_ID       = data.azuread_client_config.current.tenant_id
    ARM_SAS_TOKEN       = data.azurerm_storage_account_sas.sas.sas
  }

  repository      = var.github_repository
  secret_name     = each.key
  plaintext_value = each.value
}

# resource "null_resource" "local-provisioner" {
#   provisioner "local-exec" {
#     command = <<EOF
#       ACCOUNT_KEY=$(az storage account keys list --resource-group ${azurerm_storage_account.sa.resource_group_name} --account-name ${azurerm_storage_account.sa.name} --query '[0].value' -o tsv)
#       echo "export ARM_ACCESS_KEY=$ACCOUNT_KEY" >> ../.env
#       echo 'export STORAGE_ACCOUNT=${azurerm_storage_account.sa.name}' >> ../.env
#       echo 'export RESOURCE_GROUP=${azurerm_storage_account.sa.resource_group_name}' >> ../.env
#       echo 'export CONTAINER_NAME=${azurerm_storage_container.ct.name}' >> ../.env
#       echo 'export ARM_SAS_TOKEN="${data.azurerm_storage_account_sas.sas.sas}"' >> ../.env      
#     EOF
#   }
# }
