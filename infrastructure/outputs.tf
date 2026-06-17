# ─── Resource Group ──────────────────────────
output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

# ─── Monitoring ──────────────────────────────
output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.main.id
}

output "app_insights_connection_string" {
  value     = azurerm_application_insights.main.connection_string
  sensitive = true
}

# ─── Key Vault ───────────────────────────────
output "key_vault_uri" {
  value = azurerm_key_vault.main.vault_uri
}

# ─── Storage (docs) ─────────────────────────
output "storage_account_docs_name" {
  value = azurerm_storage_account.docs.name
}

# ─── AI Search ────────────────────────────────
output "search_endpoint" {
  value = "https://${azurerm_search_service.main.name}.search.windows.net"
}

# ─── Azure OpenAI (commented out) ────────────
# output "openai_endpoint" {
#   value = azurerm_cognitive_account.openai.endpoint
# }
#
# output "openai_embedding_deployment" {
#   value = azurerm_cognitive_deployment.embeddings.name
# }

# ─── Azure AI Foundry ─────────────────────────
output "ai_services_endpoint" {
  value = azurerm_cognitive_account.main.endpoint
}

output "embedding_deployment_name" {
  value = azurerm_cognitive_deployment.embeddings.name
}

output "chat_deployment_name" {
  value = azurerm_cognitive_deployment.chat.name
}

output "foundry_hub_id" {
  description = "Reserved for future use when upgrading to provider >= 4.14 with azurerm_ai_foundry."
  value       = null
}

output "foundry_project_id" {
  description = "Reserved for future use when upgrading to provider >= 4.14 with azurerm_ai_foundry_project."
  value       = null
}

# ─── ACR ─────────────────────────────────────
output "acr_login_server" {
  value = azurerm_container_registry.main.login_server
}


# ─── Functions ───────────────────────────────
output "function_app_name" {
  value = azurerm_linux_function_app.ingestion.name
}
