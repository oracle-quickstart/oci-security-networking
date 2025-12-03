## Copyright (c) 2025, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl


# Create VCN

resource "oci_core_virtual_network" "vcn" {
  cidr_blocks = var.ipv4_cidr_blocks
  compartment_id = var.compartment_ocid
  display_name   = "Microsegmentation"
  dns_label      = var.dns_label
}

# Create internet gateway to allow public internet traffic

resource "oci_core_internet_gateway" "ig" {
  compartment_id = var.compartment_ocid
  display_name   = "internet-gateway"
  vcn_id         = oci_core_virtual_network.vcn.id
}

# Create route table to connect vcn to internet gateway

resource "oci_core_route_table" "rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "route-table"
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.ig.id
  }
}

# Create security list to allow internet access from compute and ssh access

resource "oci_core_security_list" "access_sl" {
  compartment_id = var.compartment_ocid
  display_name   = "access-subnet-sl"
  vcn_id         = oci_core_virtual_network.vcn.id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  ingress_security_rules {

    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = 22
      min = 22
    }
  }

}

# Create regional subnets in vcn

resource "oci_core_subnet" "webtier_subnet" {
  cidr_block        = var.subnet-1
  display_name      = "web_tier_subnet"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.vcn.id
  dhcp_options_id   = oci_core_virtual_network.vcn.default_dhcp_options_id
  route_table_id    = oci_core_route_table.rt.id
  security_list_ids = [oci_core_security_list.access_sl.id]
  prohibit_public_ip_on_vnic = false

}

resource "oci_core_subnet" "apptier_subnet" {
  cidr_block        = var.subnet-2
  display_name      = "app_tier_subnet"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.vcn.id
  dhcp_options_id   = oci_core_virtual_network.vcn.default_dhcp_options_id
  route_table_id    = oci_core_route_table.rt.id
  security_list_ids = [oci_core_security_list.access_sl.id]
  prohibit_public_ip_on_vnic = true

}

resource "oci_core_subnet" "dbtier_subnet" {
  cidr_block        = var.subnet-3
  display_name      = "db_tier_subnet"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.vcn.id
  dhcp_options_id   = oci_core_virtual_network.vcn.default_dhcp_options_id
  route_table_id    = oci_core_route_table.rt.id
  security_list_ids = [oci_core_security_list.access_sl.id]
  prohibit_public_ip_on_vnic = true

}

##########################################
#              NSG CREATION              #
##########################################

resource "oci_core_network_security_group" "web_network_security_group" {
    compartment_id    = var.compartment_ocid
    display_name   = "Web"
    vcn_id         = oci_core_virtual_network.vcn.id
}

resource "oci_core_network_security_group_security_rule" "web_network_security_group_security_rule" {
  network_security_group_id = oci_core_network_security_group.web_network_security_group.id
  direction   = "INGRESS"
  protocol    = "6"
  source_type = "CIDR_BLOCK"
  source = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "web_network_security_group_security_rule_2" {
  network_security_group_id = oci_core_network_security_group.web_network_security_group.id
  direction   = "EGRESS"
  protocol    = "6"
  source_type = "CIDR_BLOCK"
  destination = "10.1.2.0/24"
  tcp_options {
    destination_port_range {
      min = 8080
      max = 8080
    }
  }
}

resource "oci_core_network_security_group" "app_network_security_group" {
    compartment_id    = var.compartment_ocid
    display_name   = "App"
    vcn_id         = oci_core_virtual_network.vcn.id
}

resource "oci_core_network_security_group_security_rule" "app_network_security_group_security_rule" {
  network_security_group_id = oci_core_network_security_group.app_network_security_group.id
  direction   = "INGRESS"
  protocol    = "6"
  source      = oci_core_network_security_group.web_network_security_group.id
  source_type = "NETWORK_SECURITY_GROUP"
  tcp_options {
    destination_port_range {
      min = 8080
      max = 8080
    }
  }
}

resource "oci_core_network_security_group_security_rule" "app_network_security_group_security_rule_2" {
  network_security_group_id = oci_core_network_security_group.app_network_security_group.id
  direction   = "EGRESS"
  protocol    = "6"
  source_type = "CIDR_BLOCK"
  destination = "10.1.3.0/24"
  tcp_options {
    destination_port_range {
      min = 1521
      max = 1521
    }
  }
}


resource "oci_core_network_security_group" "db_network_security_group" {
    compartment_id    = var.compartment_ocid
    display_name   = "Database"
    vcn_id         = oci_core_virtual_network.vcn.id
}

resource "oci_core_network_security_group_security_rule" "db_network_security_group_security_rule" {
  network_security_group_id = oci_core_network_security_group.db_network_security_group.id
  direction   = "INGRESS"
  protocol    = "6"
  source      = oci_core_network_security_group.app_network_security_group.id
  source_type = "NETWORK_SECURITY_GROUP"
  tcp_options {
    destination_port_range {
      min = 1521
      max = 1521
    }
  }
}