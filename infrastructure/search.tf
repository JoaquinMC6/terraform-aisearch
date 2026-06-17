resource "azurerm_search_service" "main" {
  name                = "srch-${local.resource_prefix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = var.search_sku
  tags                = local.common_tags

  semantic_search_sku = "standard"

  identity {
    type = "SystemAssigned"
  }
}

# ─── RBAC: Search Service → Blob Storage (indexer data access) ───────────────
resource "azurerm_role_assignment" "search_blob_reader" {
  scope                = azurerm_storage_account.docs.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_search_service.main.identity[0].principal_id
}

# ─── RBAC: Search Service → AI Services (integrated vectorization / skillsets) ─
resource "azurerm_role_assignment" "search_ai_services_user" {
  scope                = azurerm_cognitive_account.main.id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = azurerm_search_service.main.identity[0].principal_id
}


