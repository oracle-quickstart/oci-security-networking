## Copyright (c) 2025, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" { default = "" }

variable "region" { 
    description = "The OCI region deploy resources i.e. us-ashburn-1 for Ashburn or us-phoenix-1 for Phoenix Region"
    default     = "us-ashburn-1"
}

variable "compartment_ocid" { default = "" }

variable "availablity_domain_name" {
  default = ""
}

variable "vcn_a_dns_label" {
    description = "DNS label for vcn a"
    type        = string
}

variable "vcn_b_dns_label" {
    description = "DNS label for vcn b"
    type        = string
}


variable "vcn_a_ipv4_cidr_blocks" {
    description = "List of IPv4 CIDR blocks"
    type        = list(string)
}

variable "vcn_b_ipv4_cidr_blocks" {
    description = "List of IPv4 CIDR blocks"
    type        = list(string)
}

variable "subnet_a" {
  default = "10.1.1.0/24"
}

variable "subnet_b" {
  default = "10.2.2.0/24"
}
