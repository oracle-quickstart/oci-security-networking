variable "subscription_id" {
  description = "Azure subscription ID. Leave null to use the authenticated default subscription."
  type        = string
  default     = null
}

variable "application_gateway_name" {
  description = "Name of the Azure Application Gateway."
  type        = string
  default     = "appgw-ociapps-adb"
}

variable "application_gateway_resource_group_name" {
  description = "Existing resource group where the Application Gateway and public IP will be created."
  type        = string
}

variable "virtual_network_resource_group_name" {
  description = "Existing resource group that contains the VNet."
  type        = string
}

variable "virtual_network_name" {
  description = "Existing VNet name."
  type        = string
}

variable "subnet_name" {
  description = "Existing subnet name dedicated to Application Gateway."
  type        = string
}

variable "public_ip_name" {
  description = "Optional name for the public IP. Defaults to <application_gateway_name>-pip."
  type        = string
  default     = null
}

variable "zones" {
  description = "Optional availability zones for the public IP and Application Gateway."
  type        = list(string)
  default     = null
}

variable "capacity" {
  description = "Application Gateway instance capacity."
  type        = number
  default     = 1
}

variable "ssl_certificate_pfx_path" {
  description = "Local path to the frontend PFX certificate."
  type        = string
}

variable "ssl_certificate_password" {
  description = "Password for the frontend PFX certificate."
  type        = string
  sensitive   = true
}

variable "listener_host_names" {
  description = "Frontend host names accepted by the HTTPS listener."
  type        = list(string)
}

variable "backend_fqdn" {
  description = "Oracle Autonomous AI Database backend FQDN without scheme or path."
  type        = string
}

variable "backend_port" {
  description = "Backend HTTPS port."
  type        = number
  default     = 443
}

variable "backend_probe_path" {
  description = "HTTPS health probe path on the backend."
  type        = string
  default     = "/ords/apex"
}

variable "backend_probe_interval_seconds" {
  description = "Health probe interval in seconds."
  type        = number
  default     = 30
}

variable "backend_probe_timeout_seconds" {
  description = "Health probe timeout in seconds."
  type        = number
  default     = 30
}

variable "backend_probe_unhealthy_threshold" {
  description = "Number of failed probes before the backend is marked unhealthy."
  type        = number
  default     = 3
}

variable "backend_probe_match_status_codes" {
  description = "HTTP status code ranges accepted by the health probe."
  type        = list(string)
  default     = ["200-399"]
}

variable "request_timeout_seconds" {
  description = "Backend request timeout in seconds."
  type        = number
  default     = 60
}

variable "request_routing_rule_priority" {
  description = "Routing rule priority."
  type        = number
  default     = 100
}

variable "tags" {
  description = "Tags to apply to created resources."
  type        = map(string)
  default = {
    workload = "ociapps-adb"
  }
}
