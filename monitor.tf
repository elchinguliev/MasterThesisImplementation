############################################
# monitor.tf
# Centralized logging with Azure Monitor + Log Analytics
# - Log Analytics Workspace
# - Subscription Activity Logs -> Log Analytics
# - Linux VM logging (Perf + Syslog) via Data Collection Rule (DCR)
# - Associate DCR with VMs: app_vm, db_vm, webvm
############################################

############################################
# 1) Log Analytics Workspace
############################################

resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.project_name}-law"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku               = "PerGB2018"
  retention_in_days = 30
}

############################################
# 2) Subscription Activity Logs -> Log Analytics
############################################

data "azurerm_subscription" "current" {}

resource "azurerm_monitor_diagnostic_setting" "activity_to_law" {
  name                       = "${var.project_name}-activity-to-law"
  target_resource_id         = data.azurerm_subscription.current.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  # The most useful categories for auditing and troubleshooting
  enabled_log { category = "Administrative" }
  enabled_log { category = "Security" }
  enabled_log { category = "ServiceHealth" }
  enabled_log { category = "Alert" }
  enabled_log { category = "Recommendation" }
  enabled_log { category = "Policy" }
  enabled_log { category = "Autoscale" }
  enabled_log { category = "ResourceHealth" }
}

############################################
# 3) Linux VM logging (Perf + Syslog) with DCR
############################################

resource "azurerm_monitor_data_collection_rule" "linux_dcr" {
  name                = "${var.project_name}-linux-dcr"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.law.id
      name                  = "lawdest"
    }
  }

  # What streams go where
  data_flow {
    streams      = ["Microsoft-Perf", "Microsoft-Syslog"]
    destinations = ["lawdest"]
  }

  # What to collect
  data_sources {
    performance_counter {
      name                          = "perf"
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = [
        "\\Processor(_Total)\\% Processor Time",
        "\\Memory\\Available MBytes"
      ]
    }

    syslog {
      name           = "syslog"
      streams        = ["Microsoft-Syslog"]
      facility_names = ["*"]
      # Keep noise low; collect important levels
      log_levels = ["Warning", "Error", "Critical", "Alert", "Emergency"]
    }
  }
}

############################################
# 4) Associate DCR with your Linux VMs
# Your VM resources (based on your files):
# - azurerm_linux_virtual_machine.app_vm
# - azurerm_linux_virtual_machine.db_vm
# - azurerm_linux_virtual_machine.webvm
############################################

resource "azurerm_monitor_data_collection_rule_association" "app_vm_logs" {
  name                    = "${var.project_name}-appvm-logs"
  target_resource_id      = azurerm_linux_virtual_machine.app_vm.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.linux_dcr.id
}

resource "azurerm_monitor_data_collection_rule_association" "db_vm_logs" {
  name                    = "${var.project_name}-dbvm-logs"
  target_resource_id      = azurerm_linux_virtual_machine.db_vm.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.linux_dcr.id
}

resource "azurerm_monitor_data_collection_rule_association" "web_vm_logs" {
  name                    = "${var.project_name}-webvm-logs"
  target_resource_id      = azurerm_linux_virtual_machine.webvm.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.linux_dcr.id
}

############################################
# 5) Useful outputs (optional but handy)
############################################

output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.law.name
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.law.id
}
