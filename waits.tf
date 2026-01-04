resource "time_sleep" "after_vnet" {
  depends_on      = [azurerm_virtual_network.vnet]
  create_duration = "180s"
}

resource "time_sleep" "after_lb" {
  depends_on      = [azurerm_lb.lb]
  create_duration = "180s"
}
