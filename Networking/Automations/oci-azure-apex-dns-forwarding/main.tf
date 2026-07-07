data "azapi_client_config" "current" {}

locals {
  subscription_id = coalesce(var.subscription_id, data.azapi_client_config.current.subscription_id)

  application_gateway_resource_group_id = "/subscriptions/${local.subscription_id}/resourceGroups/${var.application_gateway_resource_group_name}"
  virtual_network_resource_group_id     = "/subscriptions/${local.subscription_id}/resourceGroups/${var.virtual_network_resource_group_name}"

  location = data.azapi_resource.existing_virtual_network.location

  public_ip_name                 = coalesce(var.public_ip_name, "${var.application_gateway_name}-pip")
  gateway_ip_configuration_name  = "${var.application_gateway_name}-gwip"
  frontend_ip_configuration_name = "${var.application_gateway_name}-feip-public"
  frontend_port_name             = "${var.application_gateway_name}-feport-https"
  ssl_certificate_name           = "${var.application_gateway_name}-wildcard-ociapps"
  backend_address_pool_name      = "${var.application_gateway_name}-adb-pool"
  backend_http_settings_name     = "${var.application_gateway_name}-adb-https"
  backend_probe_name             = "${var.application_gateway_name}-adb-probe"
  listener_name                  = "${var.application_gateway_name}-https-listener"
  request_routing_rule_name      = "${var.application_gateway_name}-adb-rule"

  application_gateway_id       = "${local.application_gateway_resource_group_id}/providers/Microsoft.Network/applicationGateways/${var.application_gateway_name}"
  subnet_id                    = "${data.azapi_resource.existing_virtual_network.id}/subnets/${var.subnet_name}"
  frontend_ip_configuration_id = "${local.application_gateway_id}/frontendIPConfigurations/${local.frontend_ip_configuration_name}"
  frontend_port_id             = "${local.application_gateway_id}/frontendPorts/${local.frontend_port_name}"
  ssl_certificate_id           = "${local.application_gateway_id}/sslCertificates/${local.ssl_certificate_name}"
  backend_address_pool_id      = "${local.application_gateway_id}/backendAddressPools/${local.backend_address_pool_name}"
  backend_http_settings_id     = "${local.application_gateway_id}/backendHttpSettingsCollection/${local.backend_http_settings_name}"
  backend_probe_id             = "${local.application_gateway_id}/probes/${local.backend_probe_name}"
  listener_id                  = "${local.application_gateway_id}/httpListeners/${local.listener_name}"
}

data "azapi_resource" "existing_virtual_network" {
  type      = "Microsoft.Network/virtualNetworks@2025-07-01"
  name      = var.virtual_network_name
  parent_id = local.virtual_network_resource_group_id
}

resource "azapi_resource" "public_ip" {
  type      = "Microsoft.Network/publicIPAddresses@2025-07-01"
  name      = local.public_ip_name
  parent_id = local.application_gateway_resource_group_id
  location  = local.location
  tags      = var.tags

  schema_validation_enabled = false

  body = merge(
    {
      properties = {
        publicIPAddressVersion   = "IPv4"
        publicIPAllocationMethod = "Static"
      }
      sku = {
        name = "Standard"
        tier = "Regional"
      }
    },
    var.zones == null ? {} : {
      zones = var.zones
    }
  )

  response_export_values = ["properties.ipAddress", "properties.dnsSettings.fqdn"]
}

resource "azapi_resource" "application_gateway" {
  type      = "Microsoft.Network/applicationGateways@2025-07-01"
  name      = var.application_gateway_name
  parent_id = local.application_gateway_resource_group_id
  location  = local.location
  tags      = var.tags

  schema_validation_enabled = false

  body = merge(
    {
      properties = {
        sku = {
          name     = "Standard_v2"
          tier     = "Standard_v2"
          capacity = var.capacity
        }

        gatewayIPConfigurations = [
          {
            name = local.gateway_ip_configuration_name
            properties = {
              subnet = {
                id = local.subnet_id
              }
            }
          }
        ]

        frontendIPConfigurations = [
          {
            name = local.frontend_ip_configuration_name
            properties = {
              publicIPAddress = {
                id = azapi_resource.public_ip.id
              }
            }
          }
        ]

        frontendPorts = [
          {
            name = local.frontend_port_name
            properties = {
              port = 443
            }
          }
        ]

        sslCertificates = [
          {
            name = local.ssl_certificate_name
            properties = {
              data     = filebase64(var.ssl_certificate_pfx_path)
              password = var.ssl_certificate_password
            }
          }
        ]

        backendAddressPools = [
          {
            name = local.backend_address_pool_name
            properties = {
              backendAddresses = [
                {
                  fqdn = var.backend_fqdn
                }
              ]
            }
          }
        ]

        backendHttpSettingsCollection = [
          {
            name = local.backend_http_settings_name
            properties = {
              cookieBasedAffinity        = "Disabled"
              port                       = var.backend_port
              protocol                   = "Https"
              requestTimeout             = var.request_timeout_seconds
              sniName                    = var.backend_fqdn
              validateCertChainAndExpiry = true
              validateSNI                = true
              probe = {
                id = local.backend_probe_id
              }
            }
          }
        ]

        probes = [
          {
            name = local.backend_probe_name
            properties = {
              protocol           = "Https"
              host               = var.backend_fqdn
              path               = var.backend_probe_path
              interval           = var.backend_probe_interval_seconds
              timeout            = var.backend_probe_timeout_seconds
              unhealthyThreshold = var.backend_probe_unhealthy_threshold
              match = {
                statusCodes = var.backend_probe_match_status_codes
              }
            }
          }
        ]

        httpListeners = [
          {
            name = local.listener_name
            properties = {
              frontendIPConfiguration = {
                id = local.frontend_ip_configuration_id
              }
              frontendPort = {
                id = local.frontend_port_id
              }
              protocol = "Https"
              sslCertificate = {
                id = local.ssl_certificate_id
              }
              hostNames                   = var.listener_host_names
              requireServerNameIndication = true
            }
          }
        ]

        requestRoutingRules = [
          {
            name = local.request_routing_rule_name
            properties = {
              priority = var.request_routing_rule_priority
              ruleType = "Basic"
              httpListener = {
                id = local.listener_id
              }
              backendAddressPool = {
                id = local.backend_address_pool_id
              }
              backendHttpSettings = {
                id = local.backend_http_settings_id
              }
            }
          }
        ]
      }
    },
    var.zones == null ? {} : {
      zones = var.zones
    }
  )
}
