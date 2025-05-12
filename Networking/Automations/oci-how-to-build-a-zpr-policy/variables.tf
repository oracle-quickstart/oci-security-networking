## Copyright (c) 2025, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" { default = "" }

variable "home_region" { 
    description = "The OCI region to deploy resources i.e. us-ashburn-1 for Ashburn -- NOTE: ZPR Policies can only be deployed in the Home Region"
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

variable "source-subnet" {
  default = "10.0.0.0/24"
}

variable "destination-subnet" {
  default = "10.0.1.0/24"
}

variable "instance_shape" {
  default = "VM.Standard.E5.Flex"
}

variable "ssh_public_key" {
  description = "SSH public key to use"
  type        = string
  default     = "<ssh public key>"
}

variable "instance_image_ocid" {
  description = "List of Images in each Region"
  type = map(string)
}

