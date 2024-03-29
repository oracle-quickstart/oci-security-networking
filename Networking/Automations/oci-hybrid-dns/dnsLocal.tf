## This configuration deploys DNS resources in local region
## Uncomment this file after deploying core resources for the second run
/*
resource oci_dns_resolver Spoke-VCN-2-Resolver {
  provider = oci.local_region
  compartment_id = var.compartment_ocid
  resolver_id = data.oci_core_vcn_dns_resolver_association.Spoke-VCN-2-DNS-Association.dns_resolver_id
  scope = "PRIVATE"
  freeform_tags = {
  }
  rules {
    action = "FORWARD"
    client_address_conditions = [
    ]
    destination_addresses = [
      oci_dns_resolver_endpoint.Hub-VCN-Listening.listening_address,
    ]
    qname_cover_conditions = [
    ]
    source_endpoint_name = oci_dns_resolver_endpoint.Spoke-VCN-2-Forwarding.name
  }
}

resource oci_dns_resolver Spoke-VCN-1-Resolver {
  provider = oci.local_region
  compartment_id = var.compartment_ocid
  resolver_id = data.oci_core_vcn_dns_resolver_association.Spoke-VCN-1-DNS-Association.dns_resolver_id
  freeform_tags = {
  }
  rules {
    action = "FORWARD"
    client_address_conditions = [
    ]
    destination_addresses = [
      oci_dns_resolver_endpoint.Hub-VCN-Listening.listening_address,
    ]
    qname_cover_conditions = [
    ]
    source_endpoint_name = oci_dns_resolver_endpoint.Spoke-VCN-1-Forwarding.name
  }
  scope = "PRIVATE"
}

resource oci_dns_resolver Hub-VCN-Resolver {
  provider = oci.local_region
  resolver_id = data.oci_core_vcn_dns_resolver_association.Hub-VCN-DNS-Association.dns_resolver_id
  compartment_id = var.compartment_ocid
  attached_views {
    view_id = oci_dns_resolver.Spoke-VCN-2-Resolver.default_view_id
  }
  attached_views {
    view_id = oci_dns_resolver.Spoke-VCN-1-Resolver.default_view_id
  }
  freeform_tags = {
  }
  rules {
    action = "FORWARD"
    client_address_conditions = [
    ]
    destination_addresses = [
      "1.1.1.1",
    ]
    qname_cover_conditions = [
      "internal.onprem.com",
    ]
    source_endpoint_name = oci_dns_resolver_endpoint.Hub-VCN-Forwarding.name
  }
  rules {
  action = "FORWARD"
    client_address_conditions = [
    ]
    destination_addresses = [
      oci_dns_resolver_endpoint.Remote-VCN-Listening.listening_address,
    ]
    qname_cover_conditions = [
    oci_core_vcn.Remote-VCN.vcn_domain_name
    ]
    source_endpoint_name = oci_dns_resolver_endpoint.Hub-VCN-Forwarding.name
  }
  scope = "PRIVATE"
}

resource oci_dns_resolver_endpoint Spoke-VCN-2-Forwarding {
  provider = oci.local_region
  endpoint_type      = "VNIC"
  is_forwarding      = "true"
  is_listening       = "false"
  name = "Spoke2Forwarder"
  nsg_ids = [
  ]
  resolver_id = data.oci_core_vcn_dns_resolver_association.Spoke-VCN-2-DNS-Association.dns_resolver_id
  subnet_id = oci_core_subnet.Endpoint-Subnet-Spoke-VCN-2.id
}

resource oci_dns_resolver_endpoint Spoke-VCN-1-Forwarding {
  provider = oci.local_region
  endpoint_type      = "VNIC"
  is_forwarding      = "true"
  is_listening       = "false"
  name = "Spoke1Forwarder"
  nsg_ids = [
  ]
  resolver_id = data.oci_core_vcn_dns_resolver_association.Spoke-VCN-1-DNS-Association.dns_resolver_id
  subnet_id = oci_core_subnet.Endpoint-Subnet-Spoke-VCN-1.id
}

resource oci_dns_resolver_endpoint Hub-VCN-Listening {
  provider = oci.local_region
  endpoint_type = "VNIC"
  is_forwarding     = "false"
  is_listening      = "true"
  name              = "HubListener"
  nsg_ids = [
  ]
  resolver_id = data.oci_core_vcn_dns_resolver_association.Hub-VCN-DNS-Association.dns_resolver_id
  subnet_id = oci_core_subnet.Endpoint-Subnet-Hub-VCN.id
}

resource oci_dns_resolver_endpoint Hub-VCN-Forwarding {
  provider = oci.local_region
  endpoint_type      = "VNIC"
  is_forwarding      = "true"
  is_listening       = "false"
  name = "HubForwarder"
  nsg_ids = [
  ]
  resolver_id = data.oci_core_vcn_dns_resolver_association.Hub-VCN-DNS-Association.dns_resolver_id
  subnet_id = oci_core_subnet.Endpoint-Subnet-Hub-VCN.id
}
*/
