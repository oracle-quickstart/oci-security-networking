variable "region" {
  description = "OCI region"
  type        = string
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

variable "oci_tunnel_ip" {
  description = "Placeholder IP for OCI VPN tunnel (first apply)"
  type        = string
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.1.0.0/16"
}

variable "aws_region" {
  description = "AWS region to deploy VPN resources"
  type        = string
  default     = "us-east-1"
}

variable aws_access_key {
  description = "AWS access key for login"
  type        = string
}

variable aws_secret_key{
  description = "AWS secret key for login"
  type        = string
}
variable aws_token {
  description = "AWS token for login"
  type        = string
}
