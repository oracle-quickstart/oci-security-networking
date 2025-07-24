#DRG
#==================================================
resource "oci_core_drg" "drg01" {
  compartment_id = var.compartment_id
  display_name  = "DRG01"
}
#DRG ATTACHMENT
#==================================================
resource "oci_core_drg_attachment" "hub_attachment" {
  depends_on = [ oci_core_route_table.fw_route_table ]
  drg_id     = oci_core_drg.drg01.id
  display_name = "hub-attachment"
  vcn_id = oci_core_vcn.HUB-VCN.id
  route_table_id = oci_core_route_table.fw_route_table.id  
  drg_route_table_id = oci_core_drg_route_table.hub_drg_route_table.id
}
resource "oci_core_drg_attachment" "spoke_drg_attachment" {
  for_each = var.spoke_vcn
  drg_id       = oci_core_drg.drg01.id
  vcn_id       = oci_core_vcn.spoke_vcn[each.key].id
  display_name = "${each.key}-drg-attachment"
  drg_route_table_id = oci_core_drg_route_table.spoke_drg_route_table[each.key].id
}
#DRG SPOKE ROUTE-TABLE
#==================================================
resource "oci_core_drg_route_table" "spoke_drg_route_table" {
  for_each = var.spoke_vcn
    drg_id = oci_core_drg.drg01.id
    display_name = "${each.key}_drg_route_table"
    
}
resource "oci_core_drg_route_table_route_rule" "spoke_drg_route_table_rule" {
  for_each = var.spoke_vcn
  depends_on = [oci_core_drg_attachment.hub_attachment]
    #Required
    drg_route_table_id = oci_core_drg_route_table.spoke_drg_route_table[each.key].id
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    next_hop_drg_attachment_id = oci_core_drg_attachment.hub_attachment.id
}
#DRG HUB ROUTE-TABLE
#==================================================
resource "oci_core_drg_route_table" "hub_drg_route_table" {
    drg_id = oci_core_drg.drg01.id
    display_name = "hub_drg_route_table"
}
resource "oci_core_drg_route_table_route_rule" "hub_drg_route_table_rule" {
    for_each = var.spoke_vcn
    #Required
    drg_route_table_id = oci_core_drg_route_table.hub_drg_route_table.id
    destination = each.value.cidr_block
    destination_type = "CIDR_BLOCK"
    next_hop_drg_attachment_id = oci_core_drg_attachment.spoke_drg_attachment[each.key].id
}
resource "oci_core_route_table" "fw_route_table" { 
 depends_on = [ oci_core_instance.forigate, oci_core_vnic_attachment.trust_vnic ]
 compartment_id = var.compartment_id
 vcn_id         = oci_core_vcn.HUB-VCN.id
 display_name   = "fw_route_table"
 route_rules {
 network_entity_id = data.oci_core_private_ips.forti_trust_subnet_private_ip.private_ips[0].id
 description    = "route-traffic-to-fw"
 destination    = "0.0.0.0/0"
 destination_type = "CIDR_BLOCK"
 }
 }
#HUB VCN deployement
#==================================================
resource "oci_core_vcn" "HUB-VCN" {
  compartment_id = var.compartment_id
  cidr_block     = var.hub_vcn_cidr
  display_name   = "HUB-VCN"
  dns_label = "hubvcn"
}

resource "oci_core_subnet" "forti_mgmt_subnet" {
  depends_on = [ oci_core_security_list.hub_security_list ]
  compartment_id      = var.compartment_id
  cidr_block          = var.forti_mgmt_subnet
  vcn_id              = oci_core_vcn.HUB-VCN.id
  display_name        = "forti_mgmt_subnet"
  dns_label           = "fortimgmt"
  route_table_id = oci_core_route_table.hub_route_table_internet.id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  prohibit_public_ip_on_vnic = false
  security_list_ids = [oci_core_security_list.hub_security_list.id]
}

resource "oci_core_subnet" "forti_untrust_subnet" {
  compartment_id      = var.compartment_id
  vcn_id              = oci_core_vcn.HUB-VCN.id
  display_name        = "forti_untrust_subnet"
  dns_label           = "fortiuntrust"
  cidr_block          = var.forti_untrust_subnet
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
}

resource "oci_core_subnet" "forti_trust_subnet" {
  compartment_id      = var.compartment_id
  vcn_id              = oci_core_vcn.HUB-VCN.id
  display_name        = "forti_trust_subnet"
  dns_label           = "fortitrust"
  cidr_block          = var.forti_trust_subnet
  route_table_id = oci_core_route_table.trust_subnet_routetable.id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  security_list_ids = [oci_core_security_list.trust_security_list.id]
}


resource "oci_core_security_list" "hub_security_list" {
  compartment_id = var.compartment_id
  display_name   = "HUB-SL"
  vcn_id = oci_core_vcn.HUB-VCN.id 
  ingress_security_rules {
    protocol    = "all"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
  }
  egress_security_rules {
    protocol    = "all"
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }
}
resource "oci_core_route_table" "hub_route_table_internet" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.HUB-VCN.id
  display_name   = "hub_public_route_table"
  # Internet Gateway rule
  route_rules {
    network_entity_id = oci_core_internet_gateway.hub_internet_gateway.id
    description       = "internet-gateway-rule"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
 
}
resource "oci_core_internet_gateway" "hub_internet_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.HUB-VCN.id
  enabled        = var.internet_gateway_enabled
  display_name   = "hub_internet_gateway"
}
resource "oci_core_route_table" "trust_subnet_routetable" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.HUB-VCN.id
  display_name   = "trust_subnet_routetable"  
  # Dynamic rules to route to spoke VCNs
  dynamic "route_rules" {
    for_each = var.spoke_vcn
    content {
      network_entity_id = oci_core_drg.drg01.id
      description        = "route traffic to ${route_rules.key}"
      destination        = route_rules.value.cidr_block
      destination_type   = "CIDR_BLOCK"
    }
  }
}
resource "oci_core_security_list" "trust_security_list" {
  compartment_id = var.compartment_id
  display_name   = "trust-securitylist"
  vcn_id = oci_core_vcn.HUB-VCN.id 
  ingress_security_rules {
    protocol    = "all"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
  }
  egress_security_rules {
    protocol    = "all"
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }
}
data "oci_core_private_ips" "forti_trust_subnet_private_ip" { 
  depends_on = [ oci_core_instance.forigate, oci_core_vnic_attachment.trust_vnic ]
  subnet_id = oci_core_subnet.forti_trust_subnet.id
  filter {
    name   = "display_name"
    values = ["trust_vnic"]
  }
}