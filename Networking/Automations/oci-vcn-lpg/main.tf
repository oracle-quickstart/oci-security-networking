## Copyright (c) 2026, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  region       = var.region != "" ? var.region : "us-ashburn-1"
}

##############################
#          VCN A              #
##############################

resource "oci_core_virtual_network" "vcn_a" {
  cidr_blocks    = var.vcn_a_ipv4_cidr_blocks
  compartment_id = var.compartment_ocid
  display_name   = "vcn a"
  dns_label      = var.vcn_a_dns_label
}


# Create route table to reach vcn b network via lpg a gateway

resource "oci_core_route_table" "vcn_a_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn_a.id
  display_name   = "route-table"
  route_rules {
    destination       = var.vcn_b_ipv4_cidr_blocks[0]
    network_entity_id = oci_core_local_peering_gateway.lpg_a.id
  }
}

# Create vcn asecurity list to allow access to vcn b


resource "oci_core_security_list" "vcn_a_sl" {
  compartment_id = var.compartment_ocid
  display_name   = "vcn a sl"
  vcn_id         = oci_core_virtual_network.vcn_a.id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  ingress_security_rules {
    protocol = "6"
    source   = var.vcn_b_ipv4_cidr_blocks[0]
  }

}

# Create regional subnet in vcn a

resource "oci_core_subnet" "subnet_a" {
  cidr_block                  = var.subnet_a
  display_name                = "subnet a"
  compartment_id              = var.compartment_ocid
  vcn_id                      = oci_core_virtual_network.vcn_a.id
  dhcp_options_id             = oci_core_virtual_network.vcn_a.default_dhcp_options_id
  route_table_id              = oci_core_route_table.vcn_a_rt.id
  security_list_ids           = [oci_core_security_list.vcn_a_sl.id]
  prohibit_public_ip_on_vnic  = false
}


##############################
#          VCN B              #
##############################

resource "oci_core_virtual_network" "vcn_b" {
  cidr_blocks    = var.vcn_b_ipv4_cidr_blocks
  compartment_id = var.compartment_ocid
  display_name   = "vcn b"
  dns_label      = var.vcn_b_dns_label
}


# Create route table to reach vcn a network via lpg b gateway

resource "oci_core_route_table" "vcn_b_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn_b.id
  display_name   = "route-table"
  route_rules {
    destination       = var.vcn_a_ipv4_cidr_blocks[0]
    network_entity_id = oci_core_local_peering_gateway.lpg_b.id
  }
}

# Create vcn asecurity list to allow access to vcn a


resource "oci_core_security_list" "vcn_b_sl" {
  compartment_id = var.compartment_ocid
  display_name   = "vcn b sl"
  vcn_id         = oci_core_virtual_network.vcn_b.id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  ingress_security_rules {
    protocol = "6"
    source   = var.vcn_a_ipv4_cidr_blocks[0]
  }

}

# Create regional subnet in vcn b

resource "oci_core_subnet" "subnet_b" {
  cidr_block                  = var.subnet_b
  display_name                = "subnet b"
  compartment_id              = var.compartment_ocid
  vcn_id                      = oci_core_virtual_network.vcn_b.id
  dhcp_options_id             = oci_core_virtual_network.vcn_b.default_dhcp_options_id
  route_table_id              = oci_core_route_table.vcn_b_rt.id
  security_list_ids           = [oci_core_security_list.vcn_b_sl.id]
  prohibit_public_ip_on_vnic  = false
}


##############################
#   LOCAL PEERING GATEWAYS    #
##############################

resource "oci_core_local_peering_gateway" "lpg_a" {
  compartment_id = var.compartment_ocid
  display_name   = "lpg a"
  peer_id        = oci_core_local_peering_gateway.lpg_b.id
  vcn_id         = oci_core_virtual_network.vcn_a.id
}

resource "oci_core_local_peering_gateway" "lpg_b" {
  compartment_id = var.compartment_ocid
  display_name   = "lpg b"
  vcn_id         = oci_core_virtual_network.vcn_b.id
}

