resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_vpn_gateway" "vpn_gw" {
  amazon_side_asn = "64512"
}

resource "aws_vpn_gateway_attachment" "vpn_attach" {
  vpc_id         = aws_vpc.main.id
  vpn_gateway_id = aws_vpn_gateway.vpn_gw.id
}

# Customer Gateway points to OCI IP — use placeholder or known IP
resource "aws_customer_gateway" "cgw" {
  bgp_asn    = 65010
  ip_address = var.oci_tunnel_ip # known or placeholder until OCI created
  type       = "ipsec.1"
    lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpn_connection" "vpn" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gw.id
  customer_gateway_id = aws_customer_gateway.cgw.id
  type                = "ipsec.1"
  static_routes_only  = true
  tunnel1_preshared_key = var.oci_tunnel_psk
  tunnel2_preshared_key = var.oci_tunnel_psk
}