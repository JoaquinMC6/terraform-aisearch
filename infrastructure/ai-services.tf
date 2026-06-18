resource "azurerm_cognitive_account" "main" {
  name                = "ais-${local.resource_prefix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  kind     = "AIServices"
  sku_name = "S0"

  tags = local.common_tags
}

# ─── Azure AI Foundry Hub ────────────────────────────────────────────────────
# Wraps the AI Services account into a Foundry Hub. Projects are created under
# the Hub and access its model deployments and connected resources.
resource "azurerm_ai_foundry" "main" {
  name                = "hub-${local.resource_prefix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  storage_account_id  = azurerm_storage_account.docs.id
  key_vault_id        = azurerm_key_vault.main.id

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

# ─── Azure AI Foundry Project ─────────────────────────────────────────────────
resource "azurerm_ai_foundry_project" "ingestion" {
  name               = "proj-ingestion-${local.resource_prefix}"
  location           = azurerm_ai_foundry.main.location
  ai_services_hub_id = azurerm_ai_foundry.main.id

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

# ─── RBAC: Foundry Project → Search Service ─────────────────────────────────
# Grants the Foundry Project's managed identity access to the AI Search
# resource so it can create/query indexes and manage the search service.
resource "azurerm_role_assignment" "foundry_search_index_contributor" {
  scope                = azurerm_search_service.main.id
  role_definition_name = "Search Index Data Contributor"
  principal_id         = azurerm_ai_foundry_project.ingestion.identity[0].principal_id
}

resource "azurerm_role_assignment" "foundry_search_service_contributor" {
  scope                = azurerm_search_service.main.id
  role_definition_name = "Search Service Contributor"
  principal_id         = azurerm_ai_foundry_project.ingestion.identity[0].principal_id
}



# ─── Model deployments ────────────────────────────────────────────────────────

resource "azurerm_cognitive_deployment" "embeddings" {
  name                 = "embedding-model"
  cognitive_account_id = azurerm_cognitive_account.main.id

  model {
    format  = "OpenAI"
    name    = var.embedding_model_name
    version = var.embedding_model_version
  }

  sku {
    name     = "GlobalStandard"
    capacity = var.embedding_capacity
  }
}

resource "azurerm_cognitive_deployment" "chat" {
  name                 = "chat-model"
  cognitive_account_id = azurerm_cognitive_account.main.id

  model {
    format  = "OpenAI"
    name    = var.chat_model_name
    version = var.chat_model_version
  }

  sku {
    name     = "GlobalStandard"
    capacity = var.chat_capacity
  }
}
