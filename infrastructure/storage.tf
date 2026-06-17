resource "azurerm_storage_account" "docs" {
  name                     = "st${replace(local.resource_prefix, "-", "")}docs"
  location                 = azurerm_resource_group.main.location
  resource_group_name      = azurerm_resource_group.main.name
  account_tier             = "Standard"
  account_replication_type = var.storage_replication
  min_tls_version          = "TLS1_2"
  tags                     = local.common_tags

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }
}

resource "azurerm_storage_container" "documents" {
  name                  = "documents"
  storage_account_id  = azurerm_storage_account.docs.id
  container_access_type = "private"
}
