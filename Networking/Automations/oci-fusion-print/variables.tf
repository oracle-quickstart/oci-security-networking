variable "compartment_ocid" {
  description = "compartment id where to create all resources"
  
  type        = string 
}
variable "vcn_cidrs" {
  description = "The IPv4 CIDR block the VCN will use."
  
  type        = string
}

variable "region" {
  description = "The OCI region where you want these resources deployed.  It is recommended you choose the same region as your Fusion application is hosted in."
  
  validation {
    condition     = length(trim(var.region, "")) > 0
    error_message = "Validation failed for region: value is required."
  }
}

variable "vcn_name" {
  description = "user-friendly name of to use for the vcn to be appended to the label_prefix"
  
  type        = string
  default     = "VCN"
  validation {
    condition     = length(var.vcn_name) > 0
    error_message = "The vcn_name value cannot be an empty string."
  }
}

variable "label_prefix" {
  description = "a string that will be prepended to all resources"
  
  type        = string
  default     = "Fusion_Print"
}

variable "vcn_dns_label" {
  description = "A DNS label for the VCN, used in conjunction with the VNIC's hostname and subnet's DNS label to form a fully qualified domain name (FQDN) for each VNIC within this subnet. DNS resolution of hostnames in the VCN is disabled when null."
  
  type        = string
  default     = "fusionprintvcn"

  validation {
    condition     = var.vcn_dns_label == null ? true : length(regexall("^[^0-9][a-zA-Z0-9_]{1,14}$", var.vcn_dns_label)) > 0
    error_message = "DNS label must be unset to disable, or an alphanumeric string with length of 1 through 15 that begins with a letter."
  }
}

variable "subnet_cidr_block" {
  description = "CIDR block for public subnet."
  
  type        = string
}

variable "subnet_dns_label" {
  description = "A DNS label for the public subnet, used in conjunction with the VNIC's hostname and VCN's DNS label to form a fully qualified domain name (FQDN) for each VNIC within this subnet. DNS resolution of hostnames in the VCN is disabled when null."
  
  type        = string
  default     = "fusionprintsn"

  validation {
    condition     = var.subnet_dns_label == null ? true : length(regexall("^[^0-9][a-zA-Z0-9_]{1,14}$", var.subnet_dns_label)) > 0
    error_message = "DNS label must be unset to disable, or an alphanumeric string with length of 1 through 15 that begins with a letter."
  }
}

variable "subnet_name" {
  description = "user-friendly name of to use for the subnet to be appended to the label_prefix"
  
  type        = string
  default     = "Public_Subnet"
  validation {
    condition     = length(var.subnet_name) > 0
    error_message = "The subnet_name value cannot be an empty string."
  }
}

variable "route_table_display_name" {
  description = "user-friendly name of the public subnet route table"
  
  type        = any
  default     = "Public Subnet Route Table"
}

variable "internet_gateway_display_name" {
  description = "user-friendly name of the internet gateway"
  
  type        = any
  default     = "IGW"
}

variable "fusion_source_cidr" {
  description = "Fusion Source CIDR"
  
  type        = string
}

variable "drg_display_name" {
  description = "user-friendly name of the drg"
  
  type        = any
  default     = "DRG"
}

variable "drg_attachment_display_name" {
  description = "user-friendly name of the drg vcn attachment"
  
  type        = any
  default     = "VCN Attachment"
}

variable "on_prem_printer_ip" {
  description = "IP address of on-prem printer or print server e.g. 10.0.0.10"
  
  type        = string
}

variable "on_prem_printer_network" {
  description = "Network of on-prem printer or print server including mask e.g. 10.0.0.0/24"
  
  type        = string
}

variable "load_balancer_display_name" {
  description = "user-friendly name of the flexible load balancer"
  
  type        = any
  default     = "Flexible Load Balancer"
}

variable "load_balancer_shape_details_maximum_bandwidth_in_mbps" {
  description = "Load Balancer Maximum Bandwidth"
  
  type        = number
  default     = 10
}

variable "load_balancer_shape_details_minimum_bandwidth_in_mbps" {
  description = "Load Balancer Minimum Bandwidth"
  
  type        = number
  default     = 10
}