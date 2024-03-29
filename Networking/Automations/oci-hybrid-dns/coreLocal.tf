## This configuration deploys core networking resources in local region

resource oci_core_drg_attachment Spoke-VCN-2-Attachment {
  provider = oci.local_region
  defined_tags = {
  }
  display_name       = "Spoke-VCN-2-Attachment"
  drg_id             = oci_core_drg.DRG-local.id
  freeform_tags = {
  }
  network_details {
    id = oci_core_vcn.Spoke-VCN-2.id
    type           = "VCN"
    vcn_route_type = "SUBNET_CIDRS"
  }
}

resource oci_core_drg_attachment Spoke-VCN-1-Attachment {
  provider = oci.local_region
  defined_tags = {
  }
  display_name       = "Spoke-VCN-1-Attachment"
  drg_id             = oci_core_drg.DRG-local.id
  freeform_tags = {
  }
  network_details {
    id = oci_core_vcn.Spoke-VCN-1.id
    type           = "VCN"
    vcn_route_type = "SUBNET_CIDRS"
  }
}

resource oci_core_drg_attachment Hub-VCN-Attachment {
  provider = oci.local_region
  defined_tags = {
  }
  display_name       = "Hub-VCN-Attachment"
  drg_id             = oci_core_drg.DRG-local.id
  freeform_tags = {
  }
  network_details {
    id = oci_core_vcn.Hub-VCN.id
    type           = "VCN"
    vcn_route_type = "SUBNET_CIDRS"
  }
}

resource oci_core_remote_peering_connection RPC-TO-Remote {
  provider = oci.local_region
  compartment_id = var.compartment_ocid
  display_name = "RPC-TO-Remote"
  drg_id       = oci_core_drg.DRG-local.id
  freeform_tags = {
  }
  peer_id          = oci_core_remote_peering_connection.RPC-TO-Local.id
  peer_region_name = var.remote_region
}

resource oci_core_drg DRG-local {
  provider = oci.local_region
  compartment_id = var.compartment_ocid
  display_name = "DRG-local"
  freeform_tags = {
  }
}

resource oci_core_subnet Endpoint-Subnet-Spoke-VCN-1 {
  provider = oci.local_region
  cidr_block     = var.Endpoint-Subnet-Spoke-VCN-1-CIDR
  compartment_id = var.compartment_ocid
  dhcp_options_id = oci_core_vcn.Spoke-VCN-1.default_dhcp_options_id
  display_name    = "Endpoint-Subnet-Spoke-VCN-1"
  dns_label       = "endpointsubnet"
  freeform_tags = {
  }
  ipv6cidr_blocks = [
  ]
  prohibit_internet_ingress  = "true"
  prohibit_public_ip_on_vnic = "true"
  route_table_id             = oci_core_route_table.Spoke-VCN-1-Endpoint-RT.id
  security_list_ids = [
    oci_core_security_list.Spoke-VCN-1-Endpoint-SL.id,
  ]
  vcn_id = oci_core_vcn.Spoke-VCN-1.id
}

resource oci_core_subnet Endpoint-Subnet-Hub-VCN {
  provider = oci.local_region
  cidr_block     = var.Endpoint-Subnet-Hub-VCN-CIDR
  compartment_id = var.compartment_ocid
  dhcp_options_id = oci_core_vcn.Hub-VCN.default_dhcp_options_id
  display_name    = "Endpoint-Subnet-Hub-VCN"
  dns_label       = "endpointsubnet"
  freeform_tags = {
  }
  ipv6cidr_blocks = [
  ]
  prohibit_internet_ingress  = "true"
  prohibit_public_ip_on_vnic = "true"
  route_table_id             = oci_core_route_table.Hub-Endpoint-RT.id
  security_list_ids = [
    oci_core_security_list.Hub-VCN-Endpoint-SL.id,
  ]
  vcn_id = oci_core_vcn.Hub-VCN.id
}

resource oci_core_subnet Endpoint-Subnet-Spoke-VCN-2 {
  provider = oci.local_region
  cidr_block     = var.Endpoint-Subnet-Spoke-VCN-2-CIDR
  compartment_id = var.compartment_ocid
  display_name    = "Endpoint-Subnet-Spoke-VCN-2"
  dns_label       = "endpointsubnet"
  freeform_tags = {
  }
  ipv6cidr_blocks = [
  ]
  prohibit_internet_ingress  = "true"
  prohibit_public_ip_on_vnic = "true"
  route_table_id             = oci_core_route_table.Spoke-VCN-2-Endpoint-RT.id
  security_list_ids = [
    oci_core_security_list.Spoke-VCN-2-Endpoint-SL.id,
  ]
  vcn_id = oci_core_vcn.Spoke-VCN-2.id
}

resource oci_core_vcn Spoke-VCN-2 {
  provider = oci.local_region
  cidr_blocks = [
    var.Spoke-VCN-2-CIDR,
  ]
  compartment_id = var.compartment_ocid
  display_name = "Spoke-VCN-2"
  dns_label    = "spokevcn2"
  freeform_tags = {
  }
  ipv6private_cidr_blocks = [
  ]
}

resource oci_core_vcn Spoke-VCN-1 {
  provider = oci.local_region
  cidr_blocks = [
    var.Spoke-VCN-1-CIDR,
  ]
  compartment_id = var.compartment_ocid
  display_name = "Spoke-VCN-1"
  dns_label    = "spokevcn1"
  freeform_tags = {
  }
  ipv6private_cidr_blocks = [
  ]
}

resource oci_core_vcn Hub-VCN {
  provider = oci.local_region
  cidr_blocks = [
    var.Hub-VCN-CIDR,
  ]
  compartment_id = var.compartment_ocid
  display_name = "Hub-VCN"
  dns_label    = "hubvcn"
  freeform_tags = {
  }
  ipv6private_cidr_blocks = [
  ]
}

resource oci_core_route_table Spoke-VCN-1-Endpoint-RT {
  provider = oci.local_region
  compartment_id = var.compartment_ocid
  display_name = "Spoke-VCN-1-Endpoint-RT"
  freeform_tags = {
  }
  route_rules {
    destination       = var.Hub-VCN-CIDR
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_drg.DRG-local.id
  }
  vcn_id = oci_core_vcn.Spoke-VCN-1.id
}

resource oci_core_route_table Hub-Endpoint-RT {
  provider = oci.local_region
  compartment_id = var.compartment_ocid
  display_name = "Hub-Endpoint-RT"
  freeform_tags = {
  }
  route_rules {
    #description = <<Optional value not found in discovery>>
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_drg.DRG-local.id
  }
  vcn_id = oci_core_vcn.Hub-VCN.id
}

resource oci_core_route_table Spoke-VCN-2-Endpoint-RT {
  provider = oci.local_region
  compartment_id = var.compartment_ocid
  display_name = "Spoke-VCN-2-Endpoint-RT"
  freeform_tags = {
  }
  route_rules {
    description       = "Route to send DNS query to the Hub VCN"
    destination       = var.Hub-VCN-CIDR
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_drg.DRG-local.id
  }
  vcn_id = oci_core_vcn.Spoke-VCN-2.id
}

resource oci_core_security_list Spoke-VCN-1-Endpoint-SL {
  provider = oci.local_region
  compartment_id = var.compartment_ocid
  display_name = "Endpoint-SL"
  egress_security_rules {
    destination      = var.Hub-VCN-CIDR
    destination_type = "CIDR_BLOCK"
    protocol  = "17"
    stateless = "false"
    udp_options {
      max = "53"
      min = "53"
    }
  }
  freeform_tags = {
  }
  vcn_id = oci_core_vcn.Spoke-VCN-1.id
}

resource oci_core_security_list Hub-VCN-Endpoint-SL {
  provider = oci.local_region
  compartment_id = var.compartment_ocid
  display_name = "Hub-VCN-Endpoint-SL"
  freeform_tags = {
  }
  ingress_security_rules {
    protocol    = "17"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    udp_options {
      max = "53"
      min = "53"
    }
  }
  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol  = "17"
    stateless = "false"
    udp_options {
      max = "53"
      min = "53"
    }
  }
  vcn_id = oci_core_vcn.Hub-VCN.id
}

resource oci_core_security_list Spoke-VCN-2-Endpoint-SL {
  provider = oci.local_region
  compartment_id = var.compartment_ocid
  display_name = "Spoke-VCN-2-Endpoint-SL"
  egress_security_rules {
    destination      = var.Hub-VCN-CIDR
    destination_type = "CIDR_BLOCK"
    #icmp_options = <<Optional value not found in discovery>>
    protocol  = "17"
    stateless = "false"
    #tcp_options = <<Optional value not found in discovery>>
    udp_options {
      max = "53"
      min = "53"
    }
  }
  freeform_tags = {
  }
  vcn_id = oci_core_vcn.Spoke-VCN-2.id
}
