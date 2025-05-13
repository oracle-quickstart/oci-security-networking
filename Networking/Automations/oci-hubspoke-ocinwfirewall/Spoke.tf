# VCN Resource
resource "oci_core_vcn" "spoke_vcn" {
  for_each = var.spoke_vcn

  compartment_id = var.compartment_id
  cidr_block     = each.value.cidr_block
  display_name   = each.key
  dns_label      = each.value.dns_label
}

# Public Subnet for each Spoke
resource "oci_core_subnet" "public_subnet" {
  depends_on = [ oci_core_security_list.spoke_security_list ]
  for_each = var.spoke_vcn

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.spoke_vcn[each.key].id
  cidr_block     = each.value.public_subnet_cidr
  display_name   = "${each.key}-public"
  dns_label      = "${each.key}public"
  route_table_id = oci_core_route_table.spoke_public_route_table[each.key].id
  security_list_ids = [oci_core_security_list.spoke_security_list[each.key].id]
}

# Private Subnet for each Spoke
resource "oci_core_subnet" "private_subnet" {
  for_each = var.spoke_vcn

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.spoke_vcn[each.key].id
  cidr_block     = each.value.private_subnet_cidr
  display_name   = "${each.key}-private"
  dns_label      = "${each.key}private"
  route_table_id = oci_core_route_table.spoke_private_route_table[each.key].id
  security_list_ids = [oci_core_security_list.spoke_security_list[each.key].id]
}

resource "oci_core_security_list" "spoke_security_list" {
  for_each = var.spoke_vcn

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.spoke_vcn[each.key].id
  display_name   = "${each.key}-SL"

  # Allow ICMP only from other spokes
  dynamic "ingress_security_rules" {
    for_each = {
      for k, v in var.spoke_vcn : k => v.cidr_block
      if k != each.key
    }
    content {
      protocol    = "1"
      source      = ingress_security_rules.value
      source_type = "CIDR_BLOCK"
    }
  }
  # Allow TCP from anywhere (e.g., SSH, HTTP)
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
  }
  egress_security_rules {
    protocol    = "all"
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }
}

# Route Table for Public Subnet (per spoke)
resource "oci_core_route_table" "spoke_public_route_table" {
  for_each = var.spoke_vcn

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.spoke_vcn[each.key].id
  display_name   = "${each.key}-public-route-table"

  route_rules {
    network_entity_id = oci_core_drg.drg01.id
    description       = "internet-gateway-rule"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
  route_rules  {
      destination       = "${var.my_public_ip}/32"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = oci_core_internet_gateway.spoke_igw[each.key].id 
      description       = "Route to my desktop public IP"
    }
}

resource "oci_core_route_table" "spoke_private_route_table" {
  for_each = var.spoke_vcn

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.spoke_vcn[each.key].id
  display_name   = "${each.key}-private-route-table"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_drg.drg01.id
    description       = "Private subnet route to DRG"
  }
}

# Internet Gateway per Spoke
resource "oci_core_internet_gateway" "spoke_igw" {
  for_each = var.spoke_vcn

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.spoke_vcn[each.key].id
  enabled        = var.internet_gateway_enabled
  display_name   = "${each.key}-igw"
}

# NAT Gateway for each Spoke (optional, depending on the need)
resource "oci_core_nat_gateway" "spoke_nat_gateway" {
  for_each = var.spoke_vcn

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.spoke_vcn[each.key].id
  display_name   = "${each.key}-nat-gw"
}
