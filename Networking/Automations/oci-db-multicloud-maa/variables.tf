## Copyright (c) 2025, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" { default = "" }

variable "region_1" { 
    description = "The OCI region deploy primary resources i.e. us-ashburn-1 for Ashburn or us-phoenix-1 for Phoenix Region"
    default     = "us-ashburn-1"
}

variable "region_2" { 
    description = "The OCI region deploy dr resources i.e. us-ashburn-1 for Ashburn or us-phoenix-1 for Phoenix Region"
    default     = "us-phoenix-1"
}
variable "compartment_ocid" { default = "" }

variable "availablity_domain_name" {
  default = ""
}

variable "vcn_primary_dns_label" {
    description = "DNS label for primary vcn"
    type        = string
}


variable "vcn_primarytx_dns_label" {
    description = "DNS label for primary transit vcn"
    type        = string
}

variable "vcn_standby_dns_label" {
    description = "DNS label for standby vcn"
    type        = string
}

variable "vcn_dr_dns_label" {
    description = "DNS label for dr vcn"
    type        = string
}

variable "vcn_drtx_dns_label" {
    description = "DNS label for dr transit vcn"
    type        = string
}

variable "vcn_primary_ipv4_cidr_blocks" {
    description = "List of IPv4 CIDR blocks for primary vcn"
    type        = list(string)
}

variable "vcn_primarytx_ipv4_cidr_blocks" {
    description = "List of IPv4 CIDR blocks for primary transit vcn"
    type        = list(string)
}

variable "vcn_standby_ipv4_cidr_blocks" {
    description = "List of IPv4 CIDR blocks for standby vcn"
    type        = list(string)
}

variable "vcn_dr_ipv4_cidr_blocks" {
    description = "List of IPv4 CIDR blocks for dr vcn"
    type        = list(string)
}

variable "vcn_drtx_ipv4_cidr_blocks" {
    description = "List of IPv4 CIDR blocks for dr transit vcn"
    type        = list(string)
}

variable "subnet_primary" {
  default = "10.1.1.0/24"
}

variable "subnet_standby" {
  default = "10.2.2.0/24"
}

variable "subnet_dr" {
  default = "10.3.3.0/24"
}
