resource "azurerm_network_security_group" "web_nsg" {
  name                = "nsg-${local.prefix}-web"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags

  security_rule {
    name                                       = "Allow-HTTP-HTTPS-From-Internet"
    priority                                   = 100
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_ranges                    = ["80", "443"]
    source_address_prefix                      = "Internet"
    destination_application_security_group_ids = [azurerm_application_security_group.web_asg.id]
  }

  security_rule {
    name                                       = "Allow-SSH-From-Bastion"
    priority                                   = 200
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "22"
    source_address_prefix                      = "10.0.10.0/26"
    destination_application_security_group_ids = [azurerm_application_security_group.web_asg.id]
  }
}

resource "azurerm_subnet_network_security_group_association" "web_assoc" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}

resource "azurerm_network_security_group" "app_nsg" {
  name                = "nsg-${local.prefix}-app"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags

  security_rule {
    name                                       = "Allow-App-From-Web-ASG"
    priority                                   = 100
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "5000"
    source_application_security_group_ids      = [azurerm_application_security_group.web_asg.id]
    destination_application_security_group_ids = [azurerm_application_security_group.app_asg.id]
  }

  security_rule {
    name                                       = "Allow-SSH-From-Bastion"
    priority                                   = 200
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "22"
    source_address_prefix                      = "10.0.10.0/26"
    destination_application_security_group_ids = [azurerm_application_security_group.app_asg.id]
  }
}

resource "azurerm_subnet_network_security_group_association" "app_assoc" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}

resource "azurerm_network_security_group" "db_nsg" {
  name                = "nsg-${local.prefix}-db"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags

  security_rule {
    name                                       = "Allow-DB-From-App-ASG"
    priority                                   = 100
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "1433"
    source_application_security_group_ids      = [azurerm_application_security_group.app_asg.id]
    destination_application_security_group_ids = [azurerm_application_security_group.db_asg.id]
  }

  security_rule {
    name                                       = "Allow-SSH-From-Bastion"
    priority                                   = 200
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "22"
    source_address_prefix                      = "10.0.10.0/26"
    destination_application_security_group_ids = [azurerm_application_security_group.db_asg.id]
  }
}

resource "azurerm_subnet_network_security_group_association" "db_assoc" {
  subnet_id                 = azurerm_subnet.db.id
  network_security_group_id = azurerm_network_security_group.db_nsg.id
}