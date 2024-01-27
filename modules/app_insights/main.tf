resource "azurerm_log_analytics_workspace" "this" {
  name                = "workspace"
  location            = var.region
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = lookup(module.common.tags, terraform.workspace, null)
}

resource "azurerm_application_insights" "this" {
  name                = "${var.company}-${terraform.workspace}-frontend-appins-${var.region}"
  location            = var.region
  resource_group_name = var.rg_name
  workspace_id        = azurerm_log_analytics_workspace.this.id
  application_type    = "web"

  tags = lookup(module.common.tags, terraform.workspace, null)
}

resource "azurerm_monitor_action_group" "this" {
  name                = "${var.company}-${terraform.workspace}-action-group-${var.region}"
  resource_group_name = var.rg_name
  short_name          = "${terraform.workspace}actgrp"

  tags = lookup(module.common.tags, terraform.workspace, null)
}

resource "azurerm_monitor_smart_detector_alert_rule" "this" {
  name                = "${var.company}-${terraform.workspace}-frontend-smt-det-rule-${var.region}"
  resource_group_name = var.rg_name
  severity            = "Sev3"
  scope_resource_ids  = [azurerm_application_insights.this.id]
  frequency           = "PT1M"
  detector_type       = "FailureAnomaliesDetector"

  action_group {
    ids = [azurerm_monitor_action_group.this.id]
  }

  tags = lookup(module.common.tags, terraform.workspace, null)
}

module "common" {
  source = "../common"
}