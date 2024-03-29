## This configuration deploys core networking resources in remote region

resource oci_core_drg DRG-Remote {
  provider = oci.remote_region
  compartment_id = var.compartment_ocid
  display_name = "DRG-Remote"
  freeform_tags = {
  }
}

resource oci_core_vcn Remote-VCN {
  provider = oci.remote_region
  cidr_blocks = [
    var.Remote-VCN-CIDR,
  ]
  compartment_id = var.compartment_ocid
  display_name = "Remote-VCN"
  dns_label    = "remotevcn"
  freeform_tags = {
  }
  ipv6private_cidr_blocks = [
  ]
}

resource oci_core_subnet Endpoint-Subnet-Remote-VCN {
  provider = oci.remote_region
  cidr_block     = var.Endpoint-Subnet-Remote-VCN-CIDR
  compartment_id = var.compartment_ocid
  dhcp_options_id = oci_core_vcn.Remote-VCN.default_dhcp_options_id
  display_name    = "Endpoint-Subnet-Remote-VCN"
  dns_label       = "endpointsubnet"
  freeform_tags = {
  }
  ipv6cidr_blocks = [
  ]
  prohibit_internet_ingress  = "true"
  prohibit_public_ip_on_vnic = "true"
  route_table_id             = oci_core_route_table.Remote-VCN-Endpoint-RT.id
  security_list_ids = [
    oci_core_security_list.Remote-VCN-Endpoint-SL.id,
  ]
  vcn_id = oci_core_vcn.Remote-VCN.id
}

resource oci_core_route_table Remote-VCN-Endpoint-RT {
  provider = oci.remote_region
  compartment_id = var.compartment_ocid
  display_name = "Remote-VCN-Endpoint-RT"
  freeform_tags = {
  }
  route_rules {
    destination       = var.Hub-VCN-CIDR
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_drg.DRG-Remote.id
  }
  vcn_id = oci_core_vcn.Remote-VCN.id
}

resource oci_core_security_list Remote-VCN-Endpoint-SL {
  provider = oci.remote_region
  compartment_id = var.compartment_ocid
  display_name = "Remote-VCN-Endpoint-SL"
  ingress_security_rules {
    protocol    = "17"
    source      = var.Hub-VCN-CIDR
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    udp_options {
      max = "53"
      min = "53"
    }
  }
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
  vcn_id = oci_core_vcn.Remote-VCN.id
}

resource oci_core_drg_attachment Remote-VCN-Attachment {
  provider = oci.remote_region
  defined_tags = {
  }
  display_name       = "Remote-VCN-Attachment"
  drg_id             = oci_core_drg.DRG-Remote.id
  freeform_tags = {
  }
  network_details {
    id = oci_core_vcn.Remote-VCN.id
    type           = "VCN"
    vcn_route_type = "SUBNET_CIDRS"
  }
}


resource oci_core_remote_peering_connection RPC-TO-Local {
  provider = oci.remote_region
  compartment_id = var.compartment_ocid
  display_name = "RPC-TO-Local"
  drg_id       = oci_core_drg.DRG-Remote.id
  freeform_tags = {
  }
}
