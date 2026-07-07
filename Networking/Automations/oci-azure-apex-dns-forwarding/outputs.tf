output "application_gateway_id" {
  description = "Application Gateway resource ID."
  value       = azapi_resource.application_gateway.id
}

output "application_gateway_name" {
  description = "Application Gateway name."
  value       = azapi_resource.application_gateway.name
}

output "public_ip_id" {
  description = "Public IP resource ID."
  value       = azapi_resource.public_ip.id
}

output "public_ip_address" {
  description = "Public IP address assigned to the Application Gateway."
  value       = try(azapi_resource.public_ip.output.properties.ipAddress, null)
}

output "public_ip_fqdn" {
  description = "Azure-generated FQDN for the public IP, when one is returned by Azure."
  value       = try(azapi_resource.public_ip.output.properties.dnsSettings.fqdn, null)
}

output "backend_url" {
  description = "Backend URL represented by this configuration."
  value       = "https://${var.backend_fqdn}${var.backend_probe_path}"
}
