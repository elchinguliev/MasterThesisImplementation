resource "azurerm_policy_definition" "deny_internet_ssh_nsg" {
  name         = "deny-internet-ssh-nsg"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny NSG rules allowing SSH from Internet"

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Network/networkSecurityGroups/securityRules"
        },
        {
          field  = "Microsoft.Network/networkSecurityGroups/securityRules/access"
          equals = "Allow"
        },
        {
          field  = "Microsoft.Network/networkSecurityGroups/securityRules/direction"
          equals = "Inbound"
        },
        {
          anyOf = [
            {
              field  = "Microsoft.Network/networkSecurityGroups/securityRules/destinationPortRange"
              equals = "22"
            },
            {
              field    = "Microsoft.Network/networkSecurityGroups/securityRules/destinationPortRanges[*]"
              contains = "22"
            }
          ]
        },
        {
          anyOf = [
            {
              field  = "Microsoft.Network/networkSecurityGroups/securityRules/sourceAddressPrefix"
              equals = "Internet"
            },
            {
              field  = "Microsoft.Network/networkSecurityGroups/securityRules/sourceAddressPrefix"
              equals = "*"
            },
            {
              field  = "Microsoft.Network/networkSecurityGroups/securityRules/sourceAddressPrefix"
              equals = "0.0.0.0/0"
            }
          ]
        }
      ]
    }
    then = {
      effect = "deny"
    }
  })
}

resource "azurerm_resource_group_policy_assignment" "deny_internet_ssh_nsg_assignment" {
  name                 = "deny-internet-ssh-nsg"
  resource_group_id    = azurerm_resource_group.rg.id
  policy_definition_id = azurerm_policy_definition.deny_internet_ssh_nsg.id
}

#resource "azurerm_policy_definition" "require_managedby_tag" {
# name         = "require-managedby-tag"
# policy_type  = "Custom"
# mode         = "Indexed"
# display_name = "Require ManagedBy tag on resources"

# policy_rule = jsonencode({
#  if = {
#     field  = "tags['ManagedBy']"
#    exists = "false"
#  }
#  then = {
##    effect = "deny"
#  }
#})
#}

#resource "azurerm_resource_group_policy_assignment" "require_managedby_tag_assignment" {
#name                 = "require-managedby-tag"
# resource_group_id    = azurerm_resource_group.rg.id
# policy_definition_id = azurerm_policy_definition.require_managedby_tag.id
#}