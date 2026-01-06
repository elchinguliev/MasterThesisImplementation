# resource "azurerm_private_dns_resolver" "resolver" {
 # name                = "dnsr-${local.prefix}"
 # location            = var.location
 # resource_group_name = azurerm_resource_group.rg.name
 # virtual_network_id  = azurerm_virtual_network.vnet.id
 # tags                = local.tags
#}

#resource "azurerm_private_dns_resolver_inbound_endpoint" "inbound" {
 # name                    = "dnsr-${local.prefix}-in"
#  private_dns_resolver_id = azurerm_private_dns_resolver.resolver.id
 # location                = var.location
 # tags                    = local.tags

 # ip_configurations {
   # private_ip_allocation_method = "Dynamic"
  #  subnet_id                    = azurerm_subnet.dns_resolver.id
#  }
#}

#resource "azurerm_private_dns_resolver_outbound_endpoint" "outbound" {
#  name                    = "dnsr-${local.prefix}-out"
 # private_dns_resolver_id = azurerm_private_dns_resolver.resolver.id
 # location                = var.location
 # subnet_id               = azurerm_subnet.dns_resolver.id
 # tags                    = local.tags
#}
