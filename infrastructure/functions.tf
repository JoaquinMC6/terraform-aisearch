# Storage Account propio para el runtime de Functions (requisito de Azure)
resource "azurerm_storage_account" "functions" {
  name                     = "st${replace(local.resource_prefix, "-", "")}func"
  location                 = var.location_functions
  resource_group_name      = azurerm_resource_group.main.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = local.common_tags
}

resource "azurerm_service_plan" "functions" {
  name                = "asp-func-${local.resource_prefix}"
  location            = var.location_functions
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "Y1"
  tags                = local.common_tags
}

resource "azurerm_linux_function_app" "ingestion" {
  name                       = "func-${local.resource_prefix}"
  location                   = var.location_functions
  resource_group_name        = azurerm_resource_group.main.name
  service_plan_id            = azurerm_service_plan.functions.id
  storage_account_name       = azurerm_storage_account.functions.name
  storage_account_access_key = azurerm_storage_account.functions.primary_access_key
  tags                       = local.common_tags
  https_only                 = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      python_version = "3.11"
    }

    application_insights_connection_string = azurerm_application_insights.main.connection_string
  }
}


resource "azurerm_role_assignment" "ingestion_func_ai_developer" {
  scope                = azurerm_ai_foundry_project.ingestion.id
  role_definition_name = "Azure AI Developer"
  principal_id         = azurerm_linux_function_app.ingestion.identity[0].principal_id
}

# ─── RBAC: Function App → Search (push data to index) ────────────────────────
resource "azurerm_role_assignment" "func_search_contributor" {
  scope                = azurerm_search_service.main.id
  role_definition_name = "Search Index Data Contributor"
  principal_id         = azurerm_linux_function_app.ingestion.identity[0].principal_id
}

