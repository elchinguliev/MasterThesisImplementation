output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "web_vm_private_ip" {
  value = azurerm_network_interface.web_nic.private_ip_address
}

output "app_vm_private_ip" {
  value = azurerm_network_interface.app_nic.private_ip_address
}

output "db_vm_private_ip" {
  value = azurerm_network_interface.db_nic.private_ip_address
}

output "load_balancer_public_ip" {
  value = azurerm_public_ip.lb_public_ip.ip_address
}

output "load_balancer_fqdn" {
  value = azurerm_public_ip.lb_public_ip.fqdn
}

output "firewall_private_ip" {
  value = azurerm_firewall.fw.ip_configuration[0].private_ip_address
}

output "frontdoor_endpoint_host_name" {
  value = azurerm_cdn_frontdoor_endpoint.afd_endpoint.host_name
}

output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.law.name
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.law.id
}