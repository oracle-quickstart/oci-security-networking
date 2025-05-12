## Copyright (c) 2025, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" { default = "" }

variable "region" { 
    description = "The OCI region deploy resources i.e. us-ashburn-1 for Ashburn or us-phoenix-1 for Phoenix Region"
    default     = ""
}

variable "compartment_ocid" { default = "" }

variable "availablity_domain_name" {
  default = ""
}

variable "dns_label" {
    description = "DNS label for the VCN"
    type        = string
}
variable "ipv4_cidr_blocks" {
    description = "List of IPv4 CIDR blocks"
    type        = list(string)
}

variable "ipv6_cidr_block" {
    description = "IPv6 CIDR block"
    type        = string
}

variable "ipv6_cidr_block_prefix" {
    description = "IPv6 CIDR block prefix"
    type        = string
}
variable "subnet-1" {
  default = "10.0.0.0/16"
}

variable "subnet-2" {
  default = "10.1.0.0/16"
}

variable "subnet-3" {
  default = "192.168.0.0/24"
}