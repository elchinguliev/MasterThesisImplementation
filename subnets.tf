resource "azurerm_subnet" "web" {
  name                 = "snet-${local.prefix}-web"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.KeyVault"
  ]

  depends_on = [time_sleep.after_vnet]
}

resource "azurerm_subnet" "app" {
  name                 = "snet-${local.prefix}-app"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]

  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.KeyVault"
  ]

  depends_on = [time_sleep.after_vnet]
}

resource "azurerm_subnet" "db" {
  name                 = "snet-${local.prefix}-db"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]

  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.KeyVault"
  ]

  depends_on = [time_sleep.after_vnet]
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.10.0/26"]

  depends_on = [time_sleep.after_vnet]
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.30.0/26"]

  depends_on = [time_sleep.after_vnet]
}

resource "azurerm_subnet" "firewall_management" {
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.31.0/26"]

  depends_on = [time_sleep.after_vnet]
}

resource "azurerm_subnet" "dns_inbound" {
  name                 = "snet-${local.prefix}-dns-inbound"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.50.0/28"]

  delegation {
    name = "Microsoft.Network.dnsResolvers"

    service_delegation {
      name = "Microsoft.Network/dnsResolvers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }

  depends_on = [time_sleep.after_vnet]
}

resource "azurerm_subnet" "dns_outbound" {
  name                 = "snet-${local.prefix}-dns-outbound"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.51.0/28"]

  delegation {
    name = "Microsoft.Network.dnsResolvers"

    service_delegation {
      name = "Microsoft.Network/dnsResolvers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }

  depends_on = [time_sleep.after_vnet]
}

resource "azurerm_subnet" "private_endpoint" {
  name                 = "snet-${local.prefix}-private-endpoint"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.60.0/27"]

  private_endpoint_network_policies_enabled = false

  depends_on = [time_sleep.after_vnet]
}