resource "azurerm_security_center_subscription_pricing" "defender_vm" {
  tier          = "Free"
  resource_type = "VirtualMachines"
}

resource "azurerm_security_center_subscription_pricing" "defender_storage" {
  tier          = "Free"
  resource_type = "StorageAccounts"
}