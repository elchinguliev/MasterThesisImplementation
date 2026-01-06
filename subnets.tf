resource "azurerm_subnet" "web" {
  name                 = "snet-${local.prefix}-web"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on           = [time_sleep.after_vnet]
}

resource "azurerm_subnet" "app" {
  name                 = "snet-${local.prefix}-app"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
  depends_on           = [time_sleep.after_vnet]
}

resource "azurerm_subnet" "db" {
  name                 = "snet-${local.prefix}-db"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
  depends_on           = [time_sleep.after_vnet]
}

# Required name: AzureBastionSubnet
resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.10.0/26"]
  depends_on           = [time_sleep.after_vnet]
}

# DNS Private Resolver needs a dedicated subnet (usually /28)
resource "azurerm_subnet" "dns_resolver" {
  name                 = "snet-${local.prefix}-dnsresolver"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.20.0/28"]
  depends_on           = [time_sleep.after_vnet]
}
