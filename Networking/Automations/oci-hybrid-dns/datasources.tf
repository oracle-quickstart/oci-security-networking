data "oci_core_vcn_dns_resolver_association" "Spoke-VCN-2-DNS-Association" {
    provider = oci.local_region
    vcn_id = oci_core_vcn.Spoke-VCN-2.id
}
data "oci_core_vcn_dns_resolver_association" "Spoke-VCN-1-DNS-Association" {
    provider = oci.local_region
    vcn_id = oci_core_vcn.Spoke-VCN-1.id
}
data "oci_core_vcn_dns_resolver_association" "Hub-VCN-DNS-Association" {
    provider = oci.local_region
    vcn_id = oci_core_vcn.Hub-VCN.id
}
data "oci_core_vcn_dns_resolver_association" "Remote-VCN-DNS-Association" {
    provider = oci.remote_region
    vcn_id = oci_core_vcn.Remote-VCN.id
}
