resource "azurerm_virtual_machine_extension" "web_ama" {
  name                       = "AzureMonitorAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.webvm.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.29"
  auto_upgrade_minor_version = true
}

resource "azurerm_virtual_machine_extension" "app_ama" {
  name                       = "AzureMonitorAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.app_vm.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.29"
  auto_upgrade_minor_version = true
}

resource "azurerm_virtual_machine_extension" "db_ama" {
  name                       = "AzureMonitorAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.db_vm.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.29"
  auto_upgrade_minor_version = true
}