output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "app_vm_private_ip" {
  value = azurerm_network_interface.app_nic.private_ip_address
}

output "db_vm_private_ip" {
  value = azurerm_network_interface.db_nic.private_ip_address
}
