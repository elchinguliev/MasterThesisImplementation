resource "azurerm_cdn_frontdoor_profile" "afd_profile" {
  name                = "afd-${local.prefix}"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Premium_AzureFrontDoor"
  tags                = local.tags
}

resource "azurerm_cdn_frontdoor_endpoint" "afd_endpoint" {
  name                     = var.cdn_endpoint_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd_profile.id
  enabled                  = true
  tags                     = local.tags
}

resource "azurerm_cdn_frontdoor_origin_group" "afd_origin_group" {
  name                     = "lb-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd_profile.id

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    path                = "/"
    protocol            = "Http"
    interval_in_seconds = 100
    request_type        = "GET"
  }
}

resource "azurerm_cdn_frontdoor_origin" "lb_origin" {
  name                          = "lb-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.afd_origin_group.id

  host_name          = azurerm_public_ip.lb_public_ip.fqdn
  origin_host_header = azurerm_public_ip.lb_public_ip.fqdn

  http_port                      = 80
  https_port                     = 443
  priority                       = 1
  weight                         = 1000
  enabled                        = true
  certificate_name_check_enabled = false
}

resource "azurerm_cdn_frontdoor_route" "afd_route" {
  name                          = "default-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.afd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.afd_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.lb_origin.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpOnly"
  https_redirect_enabled = false
  link_to_default_domain = true
}

resource "azurerm_cdn_frontdoor_firewall_policy" "waf_policy" {
  name                = "waf${var.project_name}${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Premium_AzureFrontDoor"
  enabled             = true
  mode                = "Prevention"
  tags                = local.tags

  managed_rule {
    type    = "DefaultRuleSet"
    version = "1.0"
    action  = "Block"
  }
}

resource "azurerm_cdn_frontdoor_security_policy" "waf_security_policy" {
  name                     = "waf-security-policy"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd_profile.id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.waf_policy.id

      association {
        patterns_to_match = ["/*"]

        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_endpoint.afd_endpoint.id
        }
      }
    }
  }
}