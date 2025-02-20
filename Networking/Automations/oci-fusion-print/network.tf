resource "oci_core_vcn" "vcn" {
  # We still allow module users to declare a cidr using `vcn_cidr` instead of the now recommended `vcn_cidrs`, but internally we map both to `cidr_blocks`
  # The module always use the new list of string structure and let the customer update his module definition block at his own pace.
  cidr_blocks    = var.vcn_cidrs[*]
  compartment_id = var.compartment_ocid
  display_name   = var.label_prefix == "none" ? var.vcn_name : "${var.label_prefix}_${var.vcn_name}"
  dns_label      = var.vcn_dns_label
}

resource "oci_core_subnet" "vcn_subnet" {
  cidr_block     = var.subnet_cidr_block
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  
  display_name    = var.label_prefix == "none" ? var.subnet_name : "${var.label_prefix}_${var.subnet_name}"
  dns_label       = var.subnet_dns_label
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_route_table.public_subnet_rt.id
}

resource "oci_core_route_table" "public_subnet_rt" {
  compartment_id = var.compartment_ocid
  display_name   = var.route_table_display_name

  route_rules {
    # * With this route table, Internet Gateway is always declared as the default gateway
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.igw.id
    description       = "Terraformed - Auto-generated at Internet Gateway creation: Internet Gateway as default gateway"
  }

  route_rules {
    destination       = "${var.on_prem_printer_ip}/32"
    network_entity_id = oci_core_drg.fusion_print_drg.id
    description       = "Terraformed - Auto-generated at DRG creation: DRG as gateway for on-prem"
  }
  
  vcn_id = oci_core_vcn.vcn.id
}

resource "oci_core_network_security_group" "flb_network_security_group" {
    #Required
    compartment_id = var.compartment_ocid
    vcn_id = oci_core_vcn.vcn.id

    #Optional
    display_name = "Flexible Load Balancer NSG"
}

resource "oci_core_network_security_group_security_rule" "flb_network_security_group_ingress_security_rule" {
    #Required
    network_security_group_id = oci_core_network_security_group.flb_network_security_group.id
    direction = "INGRESS"
    protocol = "6"

    #Optional
    description = "Terraformed - Allow Print Traffic from Fusion"
    source = var.fusion_source_cidr
    source_type = "CIDR_BLOCK"
    stateless = "false"
    tcp_options {

        #Optional
        destination_port_range {
            #Required
            max = "443"
            min = "443"
        }
    }
}

resource "oci_core_network_security_group_security_rule" "flb_network_security_group_egress_security_rule" {
    #Required
    network_security_group_id = oci_core_network_security_group.flb_network_security_group.id
    direction = "EGRESS"
    protocol = "6"

    #Optional
    description = "Terraformed - Allow Flexible Load Balancer to reach on-prem backend"
    destination = "${var.on_prem_printer_ip}/32"
    destination_type = "CIDR_BLOCK"
    stateless = "false"
    tcp_options {

        #Optional
        destination_port_range {
            #Required
            max = "443"
            min = "443"
        }
    }
}

resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  display_name   = var.label_prefix == "none" ? var.internet_gateway_display_name : "${var.label_prefix}_${var.internet_gateway_display_name}"

  vcn_id = oci_core_vcn.vcn.id
}

resource "oci_core_drg" "fusion_print_drg" {
    #Required
    compartment_id = var.compartment_ocid

    #Optional
    display_name = var.label_prefix == "none" ? var.drg_display_name : "${var.label_prefix}_${var.drg_display_name}"
}

resource "oci_core_drg_attachment" "vcn_drg_attachment" {
    #Required
    drg_id = oci_core_drg.fusion_print_drg.id

    #Optional
    display_name = var.label_prefix == "none" ? var.drg_attachment_display_name : "${var.label_prefix}_${var.drg_attachment_display_name}"
    network_details {
        #Required
        id = oci_core_vcn.vcn.id
        type = "VCN"
    }
}