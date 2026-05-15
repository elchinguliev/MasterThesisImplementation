resource "azurerm_application_security_group" "web_asg" {
  name                = "asg-${local.prefix}-web"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

resource "azurerm_application_security_group" "app_asg" {
  name                = "asg-${local.prefix}-app"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

resource "azurerm_application_security_group" "db_asg" {
  name                = "asg-${local.prefix}-db"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

resource "azurerm_network_interface_application_security_group_association" "web_asg_assoc" {
  network_interface_id          = azurerm_network_interface.web_nic.id
  application_security_group_id = azurerm_application_security_group.web_asg.id
}

resource "azurerm_network_interface_application_security_group_association" "app_asg_assoc" {
  network_interface_id          = azurerm_network_interface.app_nic.id
  application_security_group_id = azurerm_application_security_group.app_asg.id
}

resource "azurerm_network_interface_application_security_group_association" "db_asg_assoc" {
  network_interface_id          = azurerm_network_interface.db_nic.id
  application_security_group_id = azurerm_application_security_group.db_asg.id
}