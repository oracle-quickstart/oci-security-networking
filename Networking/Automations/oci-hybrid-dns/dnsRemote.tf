## This configuration deploys DNS resources in remote region
## Uncomment this file after deploying core resources for the second run
/*
resource oci_dns_resolver Remote-VCN-Resolver {
  provider = oci.remote_region
  compartment_id = var.compartment_ocid
  resolver_id = data.oci_core_vcn_dns_resolver_association.Remote-VCN-DNS-Association.dns_resolver_id
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
    source_endpoint_name = oci_dns_resolver_endpoint.Remote-VCN-Forwarding.name
  }
}

resource oci_dns_resolver_endpoint Remote-VCN-Listening {
  provider = oci.remote_region
  endpoint_type = "VNIC"
  is_forwarding     = "false"
  is_listening      = "true"
  name              = "RemoteListener"
  nsg_ids = [
  ]
  resolver_id = data.oci_core_vcn_dns_resolver_association.Remote-VCN-DNS-Association.dns_resolver_id
  subnet_id = oci_core_subnet.Endpoint-Subnet-Remote-VCN.id
}

resource oci_dns_resolver_endpoint Remote-VCN-Forwarding {
  provider = oci.remote_region
  endpoint_type      = "VNIC"
  is_forwarding      = "true"
  is_listening       = "false"
  name = "RemoteForwarder"
  nsg_ids = [
  ]
  resolver_id = data.oci_core_vcn_dns_resolver_association.Remote-VCN-DNS-Association.dns_resolver_id
  subnet_id = oci_core_subnet.Endpoint-Subnet-Remote-VCN.id
}
*/
