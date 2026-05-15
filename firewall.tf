resource "azurerm_public_ip" "firewall_pip" {
  name                = "pip-${local.prefix}-firewall"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

resource "azurerm_public_ip" "firewall_mgmt_pip" {
  name                = "pip-${local.prefix}-firewall-mgmt"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

resource "azurerm_firewall_policy" "fw_policy" {
  name                = "afwp-${local.prefix}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Basic"
  tags                = local.tags
}

resource "azurerm_firewall_policy_rule_collection_group" "fw_rcg" {
  name               = "fwrcg-${local.prefix}"
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 100

  network_rule_collection {
    name     = "allow-required-outbound"
    priority = 100
    action   = "Allow"

    rule {
      name                  = "allow-web-outbound"
      protocols             = ["TCP"]
      source_addresses      = ["10.0.1.0/24"]
      destination_addresses = ["*"]
      destination_ports     = ["80", "443"]
    }

    rule {
      name                  = "allow-app-db-outbound"
      protocols             = ["TCP"]
      source_addresses      = ["10.0.2.0/24", "10.0.3.0/24"]
      destination_addresses = ["*"]
      destination_ports     = ["80", "443"]
    }

    rule {
      name                  = "allow-dns"
      protocols             = ["UDP"]
      source_addresses      = ["10.0.0.0/16"]
      destination_addresses = ["*"]
      destination_ports     = ["53"]
    }
  }

  network_rule_collection {
    name     = "deny-risky-outbound"
    priority = 200
    action   = "Deny"

    rule {
      name                  = "deny-smb-rdp-outbound"
      protocols             = ["TCP"]
      source_addresses      = ["10.0.0.0/16"]
      destination_addresses = ["*"]
      destination_ports     = ["445", "3389"]
    }
  }
}

resource "azurerm_firewall" "fw" {
  name                = "fw-${local.prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Basic"
  firewall_policy_id  = azurerm_firewall_policy.fw_policy.id
  tags                = local.tags

  ip_configuration {
    name                 = "fw-ipconfig"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall_pip.id
  }

  management_ip_configuration {
    name                 = "fw-mgmt-ipconfig"
    subnet_id            = azurerm_subnet.firewall_management.id
    public_ip_address_id = azurerm_public_ip.firewall_mgmt_pip.id
  }
}