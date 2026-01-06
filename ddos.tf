resource "azurerm_network_ddos_protection_plan" "ddos" {
  name                = "ddos-${local.prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}
