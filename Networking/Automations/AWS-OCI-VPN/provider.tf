terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 1.3.0"
    }
    aws = {
      version = "~>5.0"
    }
  }
}
provider "oci" {
  region            = var.region
  tenancy_ocid      = var.tenancy_ocid
  user_ocid         = var.user_ocid
  fingerprint       = var.fingerprint
  private_key_path  = var.private_key_path
}

provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token = var.aws_token
}
