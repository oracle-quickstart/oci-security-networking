variable "region" {
  description = "OCI region for resource provisioning"
  type        = string
  default     = "ap-singapore-1"
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

#-----------------------SPOKE INSTANCE VARIABLES-----------------------#
variable "spoke_instances" {
  description = <<EOT
A map of compute instances to be provisioned in each spoke network. Each entry contains:
- `subnet_type`: Specifies whether the instance is in a public or private subnet.
- `display_name`: The display name for the compute instance.

Example format:
{
  "spoke01" = {
    subnet_type = "public",
    display_name = "VM_Spoke01"
  },
  "spoke02" = {
    subnet_type = "private",
    display_name = "VM_Spoke02"
  }
}
EOT
  type = map(object({
    subnet_type    = string
    display_name   = string
  }))
  default = {
    "spoke01" = {
      subnet_type = "public"
      display_name = "VM_Spoke01"
    },
    "spoke02" = {
      subnet_type = "private"
      display_name = "VM_Spoke02"
    }
  }
}

variable "spoke_vm_compute_shape" {
  description = "Spoke Compute VM Shape"
  type        = string
  default     = "VM.Standard.E4.Flex"
}

variable "ssh_public_key_path" {
  description = "path for compute ssh key file"
  type        = string
}

#-----------------------SPOKE VCN VARIABLES-----------------------#
variable "spoke_vcn" {
  description = <<EOT
A map defining spoke VCN configurations, where each key represents a spoke identifier. Each entry includes:
- `cidr_block`: The CIDR block for the VCN.
- `public_subnet_cidr`: The CIDR block for the public subnet.
- `private_subnet_cidr`: The CIDR block for the private subnet.
- `dns_label`: The DNS label for the VCN.

This enables automated provisioning of multiple spoke VCNs in a hub-and-spoke architecture.
EOT
  type = map(object({
    cidr_block         = string
    public_subnet_cidr = string
    private_subnet_cidr = string
    dns_label          = string
  }))
  default = {
    "spoke01" = {
      cidr_block         = "10.10.0.0/23"
      public_subnet_cidr = "10.10.0.0/24"
      private_subnet_cidr = "10.10.1.0/24"
      dns_label          = "spoke01"
    },
    "spoke02" = {
      cidr_block         = "10.20.0.0/23"
      public_subnet_cidr = "10.20.0.0/24"
      private_subnet_cidr = "10.20.1.0/24"
      dns_label          = "spoke02"
    }
  }
}

variable "my_public_ip" {
  description = "public ip of the desktop from where you ssh the VMs"
  type = string
}

variable "hub_vcn_cidr" {
  description = "CIDR block for the HUB VCN."
  type        = string
  default     = "10.30.0.0/23"
}

variable "hub_vcn_pub_subnet" {
  description = "CIDR block for the HUB VCN public subnet."
  type        = string
  default     = "10.30.0.0/24"
}