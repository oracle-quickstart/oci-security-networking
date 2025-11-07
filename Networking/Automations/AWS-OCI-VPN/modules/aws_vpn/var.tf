
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
variable "oci_tunnel_ip" {
  description = "Public IP of OCI VPN (placeholder until OCI is built)"
  type        = string
}
variable "aws_region" {
  description = "AWS region to deploy VPN resources"
  type        = string
  default     = "us-east-1"
}
variable "oci_tunnel_psk" {
  description = "IPSec PSK"
  type        = string
  default     = "awstoocivpnsetup123"
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
