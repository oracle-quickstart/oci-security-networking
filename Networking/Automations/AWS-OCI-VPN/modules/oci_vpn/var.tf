variable "region" {
  description = "OCI region"
  type        = string
}
variable "internet_gateway_enabled" {
  description = "Flag to enable/disable the internet gateway for VCN."
  type        = bool
  default     = true
}
variable "compartment_id" {
  description = "Compartment ID"
  type        = string
  }
variable "tenancy_ocid" {
  description = "OCI tenancy OCID"
  type        = string
}
variable "user_ocid" {
  description = "OCI user OCID"
  type        = string
}
variable "fingerprint" {
  description = "API key fingerprint"
  type        = string
}
variable "private_key_path" {
  description = "Path to private key"
  type        = string
}

variable "vcn_cidr" {
  description = "CIDR block for the VCN."
  type        = string
  default     = "10.0.0.0/23"
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.1.0.0/16"
}

variable "aws_vpn_ip" {
  description = "AWS VPN public endpoint" 
  type        = string
  default     = null
}
variable "aws_tunnel1_address" {
  description = "AWS VPN tunnel1 public IP"
  type        = string
}

variable "aws_tunnel2_address" {
  description = "AWS VPN tunnel2 public IP"
  type        = string
}

variable "oci_tunnel_psk" {
  description = "IPSec PSK"
  type        = string
  default     = "awstoocivpnsetup123"
}