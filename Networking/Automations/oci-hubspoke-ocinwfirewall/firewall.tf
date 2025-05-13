#Network firewall Polcy
#==================================================
resource "oci_network_firewall_network_firewall_policy" "hub_network_firewall_policy" {
 compartment_id = var.compartment_id
 display_name = "hub-network-fw-policy"
}

resource "oci_network_firewall_network_firewall_policy_address_list" "hub_network_firewall_policy_address_list" {
    #Required
    name = "HUB-fw-address-list"
    network_firewall_policy_id = oci_network_firewall_network_firewall_policy.hub_network_firewall_policy.id
    type = "IP"

    #Optional
    addresses = [for vcn in var.spoke_vcn : vcn.cidr_block]
}

resource "oci_network_firewall_network_firewall_policy_security_rule" "hub_network_firewall_policy_security_rule" {
    depends_on = [ oci_network_firewall_network_firewall_policy_address_list.hub_network_firewall_policy_address_list ]
  name                        = "allow-all"
  action                      = "ALLOW"
  network_firewall_policy_id = oci_network_firewall_network_firewall_policy.hub_network_firewall_policy.id

  condition {
    source_address      = [oci_network_firewall_network_firewall_policy_address_list.hub_network_firewall_policy_address_list.name]
    destination_address = [oci_network_firewall_network_firewall_policy_address_list.hub_network_firewall_policy_address_list.name]
  }
  lifecycle {
    ignore_changes = [position]
  }
}


#Network firewall
#==================================================
resource "oci_network_firewall_network_firewall" "test_network_firewall" {
    depends_on = [oci_network_firewall_network_firewall_policy_security_rule.hub_network_firewall_policy_security_rule]
    #Required
    compartment_id = var.compartment_id
    network_firewall_policy_id = oci_network_firewall_network_firewall_policy.hub_network_firewall_policy.id
    subnet_id = oci_core_subnet.HUB-public_subnet.id
    display_name = "demo-fw"
}