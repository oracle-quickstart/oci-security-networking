resource "oci_core_vcn" "VCN" {
  compartment_id = var.compartment_id
  cidr_block     = var.vcn_cidr
  display_name   = "VCN"
  dns_label      = "hubvcn"
}

resource "oci_core_drg" "drg" {
  compartment_id = var.compartment_id
  display_name   = "AWS-DRG"
}

resource "oci_core_drg_attachment" "vcn_drg_attachment" {
  drg_id = oci_core_drg.drg.id
  vcn_id = oci_core_vcn.VCN.id
}

resource "oci_core_cpe" "aws_cpe" {
  compartment_id = var.compartment_id
  ip_address     = var.aws_tunnel1_address
  display_name   = "AWS-CPE"
}

resource "oci_core_ipsec" "ipsec_connection" {
  compartment_id = var.compartment_id
  cpe_id         = oci_core_cpe.aws_cpe.id
  drg_id         = oci_core_drg.drg.id
  static_routes  = [var.vpc_cidr]
  display_name   = "VPN-to-AWS"
}

resource "oci_core_ipsec_connection_tunnel_management" "tunnel1" {
  depends_on   = [oci_core_ipsec.ipsec_connection]
  ipsec_id      = oci_core_ipsec.ipsec_connection.id
  tunnel_id     = data.oci_core_ipsec_connection_tunnels.oci_tunnels.ip_sec_connection_tunnels[0].id
  shared_secret = var.oci_tunnel_psk
}

resource "oci_core_ipsec_connection_tunnel_management" "tunnel2" {
  depends_on   = [oci_core_ipsec.ipsec_connection]
  ipsec_id      = oci_core_ipsec.ipsec_connection.id
  tunnel_id     = data.oci_core_ipsec_connection_tunnels.oci_tunnels.ip_sec_connection_tunnels[1].id
  shared_secret = var.oci_tunnel_psk
}

data "oci_core_ipsec_connection_tunnels" "oci_tunnels" {
  ipsec_id = oci_core_ipsec.ipsec_connection.id
}

output "oci_tunnel1_ip" {
  value = data.oci_core_ipsec_connection_tunnels.oci_tunnels.ip_sec_connection_tunnels[0].vpn_ip
}

output "oci_tunnel2_ip" {
  value = data.oci_core_ipsec_connection_tunnels.oci_tunnels.ip_sec_connection_tunnels[1].vpn_ip
}