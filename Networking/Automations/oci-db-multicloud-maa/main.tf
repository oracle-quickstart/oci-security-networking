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
  alias        = "region_1"
  tenancy_ocid = var.tenancy_ocid
  region       = var.region_1 != "" ? var.region_1 : "us-ashburn-1"
}

provider "oci" {
  alias        = "region_2"
  tenancy_ocid = var.tenancy_ocid
  region       = var.region_2 != "" ? var.region_2 : "us-phoenix-1"
}

##############################
#          PRIMARY VCN       #
##############################

resource "oci_core_virtual_network" "vcn_primary" {
  provider       = oci.region_1
  cidr_blocks    = var.vcn_primary_ipv4_cidr_blocks
  compartment_id = var.compartment_ocid
  display_name   = "primary vcn"
  dns_label      = var.vcn_primary_dns_label
}


# Create route table to reach dr vcn via primary lpg

resource "oci_core_route_table" "vcn_primary_rt" {
  provider       = oci.region_1
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn_primary.id
  display_name   = "primary route-table"
  route_rules {
    description       = "route to dr standby vcn"    
    destination       = var.vcn_standby_ipv4_cidr_blocks[0]
    network_entity_id = oci_core_local_peering_gateway.lpg_primary_2.id
  }  
  route_rules {
    description       = "route to dr vcn"    
    destination       = var.vcn_dr_ipv4_cidr_blocks[0]
    network_entity_id = oci_core_local_peering_gateway.lpg_primary.id
  }
}

# Create vcn nsg to allow access to dr and standby vcn 

resource "oci_core_network_security_group" "custom_nsg_primary" {
    provider          = oci.region_1
    compartment_id    = var.compartment_ocid
    display_name   = "custom nsg"
    vcn_id         = oci_core_virtual_network.vcn_primary.id
}

resource "oci_core_network_security_group_security_rule" "primary_sec_rule_1" {
  provider = oci.region_1
  network_security_group_id = oci_core_network_security_group.custom_nsg_primary.id
  direction   = "INGRESS"
  protocol    = "all"
  source_type = "CIDR_BLOCK"
  source      = var.vcn_standby_ipv4_cidr_blocks[0]
}

resource "oci_core_network_security_group_security_rule" "primary_sec_rule_2" {
  provider = oci.region_1
  network_security_group_id = oci_core_network_security_group.custom_nsg_primary.id
  direction   = "INGRESS"
  protocol    = "all"
  source_type = "CIDR_BLOCK"
  source      = var.vcn_dr_ipv4_cidr_blocks[0]
}

resource "oci_core_network_security_group_security_rule" "primary_sec_rule_3" {
  provider = oci.region_1
  network_security_group_id = oci_core_network_security_group.custom_nsg_primary.id
  direction   = "EGRESS"
  protocol    = "all"
  destination_type = "CIDR_BLOCK"
  destination = var.vcn_standby_ipv4_cidr_blocks[0]
}

resource "oci_core_network_security_group_security_rule" "primary_sec_rule_4" {
  provider = oci.region_1
  network_security_group_id = oci_core_network_security_group.custom_nsg_primary.id
  direction   = "EGRESS"
  protocol    = "all"
  destination_type = "CIDR_BLOCK"
  destination = var.vcn_dr_ipv4_cidr_blocks[0]
}


# Create regional subnet in primary vcn

resource "oci_core_subnet" "subnet_primary" {
  provider                    = oci.region_1
  cidr_block                  = var.subnet_primary
  display_name                = "primary subnet"
  compartment_id              = var.compartment_ocid
  vcn_id                      = oci_core_virtual_network.vcn_primary.id
  dhcp_options_id             = oci_core_virtual_network.vcn_primary.default_dhcp_options_id
  route_table_id              = oci_core_route_table.vcn_primary_rt.id
  prohibit_public_ip_on_vnic  = true
}

##############################
#     PRIMARY TRANSIT VCN    #
##############################

resource "oci_core_virtual_network" "vcn_primarytx" {
  provider       = oci.region_1
  cidr_blocks    = var.vcn_primarytx_ipv4_cidr_blocks
  compartment_id = var.compartment_ocid
  display_name   = "primary transit vcn"
  dns_label      = var.vcn_primarytx_dns_label
}


# Create transit route table to reach primary vcn network via "primary transit lpg", dr vcn via "primary drg" attachment 

resource "oci_core_route_table" "vcn_primarytx_lpg_rt" {
  provider       = oci.region_1
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn_primarytx.id
  display_name   = "primary transit lpg route-table"
route_rules {
    description       = "route to dr vcn"    
    destination       = var.vcn_dr_ipv4_cidr_blocks[0]
    network_entity_id = oci_core_drg.drg_primary.id
  }
}

resource "oci_core_route_table" "vcn_primarytx_drg_rt" {
  provider       = oci.region_1
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn_primarytx.id
  display_name   = "primary transit drg route-table"
  route_rules {
    description       = "route to primary vcn"
    destination       = var.vcn_primary_ipv4_cidr_blocks[0]
    network_entity_id = oci_core_local_peering_gateway.lpg_primarytx.id
  }  
}

##############################
#        STANDBY VCN         #
##############################

resource "oci_core_virtual_network" "vcn_standby" {
  provider       = oci.region_1
  cidr_blocks    = var.vcn_standby_ipv4_cidr_blocks
  compartment_id = var.compartment_ocid
  display_name   = "standby vcn"
  dns_label      = var.vcn_standby_dns_label
}


# Create route table to reach primary vcn network via standby lpg

resource "oci_core_route_table" "vcn_standby_rt" {
  provider       = oci.region_1
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn_standby.id
  display_name   = "standby lpg route-table"
  route_rules {
    description       = "route to primary vcn"
    destination       = var.vcn_primary_ipv4_cidr_blocks[0]
    network_entity_id = oci_core_local_peering_gateway.lpg_standby.id
  }
}

resource "oci_core_network_security_group" "custom_nsg_standby" {
    provider          = oci.region_1
    compartment_id    = var.compartment_ocid
    display_name   = "custom nsg"
    vcn_id         = oci_core_virtual_network.vcn_standby.id
}

resource "oci_core_network_security_group_security_rule" "standby_sec_rule_1" {
  provider = oci.region_1
  network_security_group_id = oci_core_network_security_group.custom_nsg_standby.id
  direction   = "INGRESS"
  protocol    = "all"
  source_type = "CIDR_BLOCK"
  source      = var.vcn_primary_ipv4_cidr_blocks[0]
}

resource "oci_core_network_security_group_security_rule" "standby_sec_rule_2" {
  provider = oci.region_1
  network_security_group_id = oci_core_network_security_group.custom_nsg_standby.id
  direction   = "EGRESS"
  protocol    = "all"
  destination_type = "CIDR_BLOCK"
  destination = var.vcn_primary_ipv4_cidr_blocks[0]
}

resource "oci_core_network_security_group_security_rule" "standby_sec_rule_3" {
  provider = oci.region_1
  network_security_group_id = oci_core_network_security_group.custom_nsg_standby.id
  direction   = "EGRESS"
  protocol    = "all"
  destination_type = "CIDR_BLOCK"
  destination = var.vcn_dr_ipv4_cidr_blocks[0]
}

# Create regional subnet in standby vcn

resource "oci_core_subnet" "subnet_standby" {
  provider                    = oci.region_1
  cidr_block                  = var.subnet_standby
  display_name                = "standby subnet"
  compartment_id              = var.compartment_ocid
  vcn_id                      = oci_core_virtual_network.vcn_standby.id
  dhcp_options_id             = oci_core_virtual_network.vcn_standby.default_dhcp_options_id
  route_table_id              = oci_core_route_table.vcn_standby_rt.id
  prohibit_public_ip_on_vnic  = true
}



############################
#          DR VCN          #
############################

resource "oci_core_virtual_network" "vcn_dr" {
  provider       = oci.region_2
  cidr_blocks    = var.vcn_dr_ipv4_cidr_blocks
  compartment_id = var.compartment_ocid
  display_name   = "dr vcn"
  dns_label      = var.vcn_dr_dns_label
}


# Create route table to reach primrary vcn network via dr lpg

resource "oci_core_route_table" "vcn_dr_rt" {
  provider       = oci.region_2
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn_dr.id
  display_name   = "dr lpg route-table"
  route_rules {
    description       = "route to primary vcn"
    destination       = var.vcn_primary_ipv4_cidr_blocks[0]
    network_entity_id = oci_core_local_peering_gateway.lpg_dr.id
  }
}

resource "oci_core_network_security_group" "custom_nsg_dr" {
    provider          = oci.region_2
    compartment_id    = var.compartment_ocid
    display_name   = "custom nsg"
    vcn_id         = oci_core_virtual_network.vcn_dr.id
}

resource "oci_core_network_security_group_security_rule" "dr_sec_rule_1" {
  provider = oci.region_2
  network_security_group_id = oci_core_network_security_group.custom_nsg_dr.id
  direction   = "INGRESS"
  protocol    = "all"
  source_type = "CIDR_BLOCK"
  source      = var.vcn_primary_ipv4_cidr_blocks[0]
}

resource "oci_core_network_security_group_security_rule" "dr_sec_rule_2" {
  provider = oci.region_2
  network_security_group_id = oci_core_network_security_group.custom_nsg_dr.id
  direction        = "EGRESS"
  protocol         = "all"
  destination_type = "CIDR_BLOCK"
  destination      = var.vcn_primary_ipv4_cidr_blocks[0]
}


# Create regional subnet in dr vcn

resource "oci_core_subnet" "subnet_dr" {
  provider                    = oci.region_2
  cidr_block                  = var.subnet_dr
  display_name                = "dr subnet"
  compartment_id              = var.compartment_ocid
  vcn_id                      = oci_core_virtual_network.vcn_dr.id
  dhcp_options_id             = oci_core_virtual_network.vcn_dr.default_dhcp_options_id
  route_table_id              = oci_core_route_table.vcn_dr_rt.id
  prohibit_public_ip_on_vnic  = true
}

##############################
#       DR TRANSIT VCN       #
##############################
resource "oci_core_virtual_network" "vcn_drtx" {
  provider       = oci.region_2
  cidr_blocks    = var.vcn_drtx_ipv4_cidr_blocks
  compartment_id = var.compartment_ocid
  display_name   = "dr transit vcn"
  dns_label      = var.vcn_drtx_dns_label
}


# Create transit route table to reach dr vcn network via "dr transit lpg", primary vcn via "dr drg" attachment 

resource "oci_core_route_table" "vcn_drtx_lpg_rt" {
  provider       = oci.region_2
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn_drtx.id
  display_name   = "dr transit lpg route-table"
  route_rules {
    description       = "route to primary vcn"
    destination       = var.vcn_primary_ipv4_cidr_blocks[0]
    network_entity_id = oci_core_drg.drg_dr.id
  }
}

resource "oci_core_route_table" "vcn_drtx_drg_rt" {
  provider       = oci.region_2
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn_drtx.id
  display_name   = "dr transit drg route-table"
  route_rules {
    description       = "route to dr vcn"
    destination       = var.vcn_dr_ipv4_cidr_blocks[0]
    network_entity_id = oci_core_local_peering_gateway.lpg_drtx.id
  }  
}

######################################
#   PRIMARY LOCAL PEERING GATEWAYS   #
######################################

resource "oci_core_local_peering_gateway" "lpg_primary" {
  provider       = oci.region_1
  compartment_id = var.compartment_ocid
  display_name   = "primary to transit"
  peer_id        = oci_core_local_peering_gateway.lpg_primarytx.id
  vcn_id         = oci_core_virtual_network.vcn_primary.id
}

resource "oci_core_local_peering_gateway" "lpg_primarytx" {
  provider       = oci.region_1
  compartment_id = var.compartment_ocid
  display_name   = "transit to primary"
  vcn_id         = oci_core_virtual_network.vcn_primarytx.id
  route_table_id = oci_core_route_table.vcn_primarytx_lpg_rt.id  
}

resource "oci_core_local_peering_gateway" "lpg_primary_2" {
  provider       = oci.region_1
  compartment_id = var.compartment_ocid
  display_name   = "primary to standby"
  peer_id        = oci_core_local_peering_gateway.lpg_standby.id
  vcn_id         = oci_core_virtual_network.vcn_primary.id
}

resource "oci_core_local_peering_gateway" "lpg_standby" {
  provider       = oci.region_1
  compartment_id = var.compartment_ocid
  display_name   = "standby lpg"
  vcn_id         = oci_core_virtual_network.vcn_standby.id
}

###################################
#     DR LOCAL PEERING GATEWAYS   #
###################################

resource "oci_core_local_peering_gateway" "lpg_dr" {
  provider       = oci.region_2
  compartment_id = var.compartment_ocid
  display_name   = "dr to transit"
  peer_id        = oci_core_local_peering_gateway.lpg_drtx.id
  vcn_id         = oci_core_virtual_network.vcn_dr.id
}

resource "oci_core_local_peering_gateway" "lpg_drtx" {
  provider       = oci.region_2
  compartment_id = var.compartment_ocid
  display_name   = "transit to dr"
  vcn_id         = oci_core_virtual_network.vcn_drtx.id
  route_table_id = oci_core_route_table.vcn_drtx_lpg_rt.id    
}

####################################
#  PRIMARY DYNAMIC ROUTING GATEWAY #
####################################

resource "oci_core_drg" "drg_primary" {
  provider      = oci.region_1
  compartment_id = var.compartment_ocid
  display_name  = "primary drg"
}

#DRG primary transit vcn attachment
resource "oci_core_drg_attachment" "vcn_primarytx_attachment" {
  provider      = oci.region_1
  depends_on    = [oci_core_route_table.vcn_primarytx_drg_rt]
  drg_id        = oci_core_drg.drg_primary.id
  display_name  = "primary transit vcn attachment"
  vcn_id        = oci_core_virtual_network.vcn_primarytx.id
  route_table_id = oci_core_route_table.vcn_primarytx_drg_rt.id
}

#DRG primary rpc attachment
resource "oci_core_remote_peering_connection" "drg_primaryrpc_attachment" {
  provider       = oci.region_1
  compartment_id = var.compartment_ocid
  display_name   = "rpc to dr drg"
  drg_id         = oci_core_drg.drg_primary.id
  peer_id        = oci_core_remote_peering_connection.drg_drrpc_attachment.id
  peer_region_name = var.region_2
}

##################################
#   DR DYNAMIC ROUTING GATEWAY   #
##################################

resource "oci_core_drg" "drg_dr" {
  provider      = oci.region_2
  compartment_id = var.compartment_ocid
  display_name  = "dr drg"
}

#DRG dr transit vcn attachment 
resource "oci_core_drg_attachment" "vcn_drtx_attachment" {
  provider      = oci.region_2
  depends_on    = [oci_core_route_table.vcn_drtx_drg_rt]
  drg_id        = oci_core_drg.drg_dr.id
  display_name  = "dr transit vcn attachment"
  vcn_id        = oci_core_virtual_network.vcn_drtx.id
  route_table_id = oci_core_route_table.vcn_drtx_drg_rt.id
}

#DRG dr rpc attachment
resource "oci_core_remote_peering_connection" "drg_drrpc_attachment" {
  provider       = oci.region_2
  compartment_id = var.compartment_ocid
  display_name   = "rpc to primary drg"
  drg_id         = oci_core_drg.drg_dr.id
}