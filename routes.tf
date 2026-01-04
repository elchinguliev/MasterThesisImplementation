resource "azurerm_route_table" "private_rt" {
  name                = "private-rt"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_route" "default" {
  name                = "internet"
  resource_group_name = azurerm_resource_group.rg.name
  route_table_name    = azurerm_route_table.private_rt.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "Internet"
}

resource "azurerm_subnet_route_table_association" "app" {
  subnet_id      = azurerm_subnet.app.id
  route_table_id = azurerm_route_table.private_rt.id
}

resource "azurerm_subnet_route_table_association" "db" {
  subnet_id      = azurerm_subnet.db.id
  route_table_id = azurerm_route_table.private_rt.id
}
