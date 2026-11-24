terraform {
  required_version = ">= 1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    container_name   = "tfstate"
    key              = "monitoring.tfstate"
    use_oidc         = true
    use_azuread_auth = true
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}

variable "subscription_id" {
  type = string
}

variable "alert_email" {
  type = string
}

locals {
  scope = "/subscriptions/${var.subscription_id}"
  tags = {
    project    = "azure-cicd-monitoring"
    managed_by = "terraform"
  }
}

resource "azurerm_resource_group" "monitoring" {
  name     = "rg-monitoring"
  location = "norwayeast"
  tags     = local.tags
}

resource "azurerm_monitor_action_group" "email" {
  name                = "ag-email-alerts"
  resource_group_name = azurerm_resource_group.monitoring.name
  short_name          = "emailalert"
  tags                = local.tags

  email_receiver {
    name                    = "owner"
    email_address           = var.alert_email
    use_common_alert_schema = true
  }
}

# Alert when a resource group is deleted anywhere in the subscription.
resource "azurerm_monitor_activity_log_alert" "rg_deleted" {
  name                = "alert-resource-group-deleted"
  resource_group_name = azurerm_resource_group.monitoring.name
  location            = "global"
  scopes              = [local.scope]
  description         = "A resource group was deleted in the subscription."
  tags                = local.tags

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Resources/subscriptions/resourceGroups/delete"
    status         = "Succeeded"
  }

  action {
    action_group_id = azurerm_monitor_action_group.email.id
  }
}

# Alert on Azure service incidents that affect the subscription.
resource "azurerm_monitor_activity_log_alert" "service_health" {
  name                = "alert-service-health"
  resource_group_name = azurerm_resource_group.monitoring.name
  location            = "global"
  scopes              = [local.scope]
  description         = "Azure service health incident or maintenance."
  tags                = local.tags

  criteria {
    category = "ServiceHealth"

    service_health {
      events = ["Incident", "Maintenance"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.email.id
  }
}
