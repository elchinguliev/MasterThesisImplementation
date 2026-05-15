resource "azurerm_storage_account" "evidence" {
  name                     = lower(replace("${var.project_name}${var.env}evidence", "-", ""))
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  public_network_access_enabled = false

  tags = local.tags
}

resource "azurerm_private_dns_zone" "blob_private_dns" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob_dns_link" {
  name                  = "pdnslink-${local.prefix}-blob"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.blob_private_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  tags                  = local.tags
}

resource "azurerm_private_endpoint" "storage_blob_pe" {
  name                = "pe-${local.prefix}-storage-blob"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.private_endpoint.id
  tags                = local.tags

  private_service_connection {
    name                           = "psc-${local.prefix}-storage-blob"
    private_connection_resource_id = azurerm_storage_account.evidence.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob_private_dns.id]
  }
}