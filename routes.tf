resource "azurerm_route_table" "private_rt" {
  name                = "rt-${local.prefix}-private"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

# NAT gateway association is enough; route table can be kept minimal.
# OPTIONAL: If you want explicit default route, keep it, but NAT handles egress.
# Best practice: do not force 0.0.0.0/0 -> Internet for private subnets.
# We'll remove the explicit Internet route.

resource "azurerm_subnet_route_table_association" "app" {
  subnet_id      = azurerm_subnet.app.id
  route_table_id = azurerm_route_table.private_rt.id
}

resource "azurerm_subnet_route_table_association" "db" {
  subnet_id      = azurerm_subnet.db.id
  route_table_id = azurerm_route_table.private_rt.id
}
