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


variable "subnet-1" {
  default = "10.0.0.0/24"
}

variable "subnet-2" {
  default = "10.0.1.0/24"
}

variable "subnet-3" {
  default = "10.0.2.0/24"
}

# Placeholder backend server (use your own VM or app IP)
#variable "backend_server_1_ip" {}
#variable "backend_server_2_ip" {}