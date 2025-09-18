## Copyright (c) 2025, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl


# Create VCN

resource "oci_core_virtual_network" "vcn" {
  cidr_blocks = var.ipv4_cidr_blocks
  compartment_id = var.compartment_ocid
  display_name   = "NestedLBs"
  dns_label      = var.dns_label
}

# Create internet gateway to allow public internet traffic

resource "oci_core_internet_gateway" "ig" {
  compartment_id = var.compartment_ocid
  display_name   = "internet-gateway"
  vcn_id         = oci_core_virtual_network.vcn.id
}

# Create route table to connect vcn to internet gateway

resource "oci_core_route_table" "rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "route-table"
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.ig.id
  }
}

# Create security list to allow internet access from compute and ssh access

resource "oci_core_security_list" "access_sl" {
  compartment_id = var.compartment_ocid
  display_name   = "access-subnet-sl"
  vcn_id         = oci_core_virtual_network.vcn.id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  ingress_security_rules {

    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = 80
      min = 80
    }
  }

}

resource "oci_core_security_list" "customer_sl" {
  compartment_id = var.compartment_ocid
  display_name   = "customer-subnet-sl"
  vcn_id         = oci_core_virtual_network.vcn.id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  ingress_security_rules {

    protocol = "6"
    source   = "10.0.0.0/24"

  }

}

# Create regional subnets in vcn

resource "oci_core_subnet" "access_subnet" {
  cidr_block        = var.subnet-1
  display_name      = "access_subnet"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.vcn.id
  dhcp_options_id   = oci_core_virtual_network.vcn.default_dhcp_options_id
  route_table_id    = oci_core_route_table.rt.id
  security_list_ids = [oci_core_security_list.access_sl.id]
  prohibit_public_ip_on_vnic = false

}

resource "oci_core_subnet" "customer_subnet_1" {
  cidr_block        = var.subnet-2
  display_name      = "customer_subnet_1"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.vcn.id
  dhcp_options_id   = oci_core_virtual_network.vcn.default_dhcp_options_id
  route_table_id    = oci_core_route_table.rt.id
  security_list_ids = [oci_core_security_list.customer_sl.id]
  prohibit_public_ip_on_vnic = true

}

resource "oci_core_subnet" "customer_subnet_2" {
  cidr_block        = var.subnet-3
  display_name      = "customer_subnet_2"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.vcn.id
  dhcp_options_id   = oci_core_virtual_network.vcn.default_dhcp_options_id
  route_table_id    = oci_core_route_table.rt.id
  security_list_ids = [oci_core_security_list.customer_sl.id]
  prohibit_public_ip_on_vnic = true

}

##############################
# BACKEND LOAD BALANCERS (2) #
##############################

resource "oci_load_balancer_load_balancer" "backend_lb1" {
  compartment_id = var.compartment_ocid
  display_name   = "backend-lb-1"
  shape          = "flexible"
  subnet_ids     = [oci_core_subnet.customer_subnet_1.id]
  shape_details {
    minimum_bandwidth_in_mbps = 10
    maximum_bandwidth_in_mbps = 100
  }
  is_private = true
}

resource "oci_load_balancer_load_balancer" "backend_lb2" {
  compartment_id = var.compartment_ocid
  display_name   = "backend-lb-2"
  shape          = "flexible"
  subnet_ids     = [oci_core_subnet.customer_subnet_2.id]
  shape_details {
    minimum_bandwidth_in_mbps = 10
    maximum_bandwidth_in_mbps = 100
  }
  is_private = true
}

resource "oci_load_balancer_listener" "listener_lb1" {
  load_balancer_id         = oci_load_balancer_load_balancer.backend_lb1.id
  name                     = "http-listener"
  default_backend_set_name = oci_load_balancer_backend_set.backend_set_1.name
  protocol                 = "HTTP"
  port                     = 80
}

resource "oci_load_balancer_listener" "listener_lb2" {
  load_balancer_id         = oci_load_balancer_load_balancer.backend_lb2.id
  name                     = "http-listener"
  default_backend_set_name = oci_load_balancer_backend_set.backend_set_2.name
  protocol                 = "HTTP"
  port                     = 80
}

# Each backend LB will "proxy" to a sample backend server (could be updated as needed)
resource "oci_load_balancer_backend_set" "backend_set_1" {
  load_balancer_id = oci_load_balancer_load_balancer.backend_lb1.id
  name             = "backendset1"
  policy           = "ROUND_ROBIN"

  health_checker {
    protocol = "HTTP"
    url_path = "/"
    port     = 80
  }
}

resource "oci_load_balancer_backend_set" "backend_set_2" {
  load_balancer_id = oci_load_balancer_load_balancer.backend_lb2.id
  name             = "backendset2"
  policy           = "ROUND_ROBIN"

  health_checker {
    protocol = "HTTP"
    url_path = "/"
    port     = 80
  }
}

output "backend_lb1_ips" {
  value = oci_load_balancer_load_balancer.backend_lb1.ip_addresses
}

output "backend_lb2_ips" {
  value = oci_load_balancer_load_balancer.backend_lb2.ip_addresses
}

# Placeholder backend server Config
#resource "oci_load_balancer_backend" "backend1_lb1" {
#  load_balancer_id = oci_load_balancer_load_balancer.backend_lb1.id
#  backend_set_name = oci_load_balancer_backend_set.backend_set_1.name
#  ip_address       = var.backend_server_1_ip
#  port             = 80
#  weight           = 1
#}

#resource "oci_load_balancer_backend" "backend2_lb2" {
#  load_balancer_id = oci_load_balancer_load_balancer.backend_lb2.id
#  backend_set_name = oci_load_balancer_backend_set.backend_set_2.name
#  ip_address       = var.backend_server_2_ip
#  port             = 80
#  weight           = 1
#}


##############################
# FRONTEND LOAD BALANCER     #
##############################

resource "oci_load_balancer_load_balancer" "frontend_lb" {
  compartment_id = var.compartment_ocid
  display_name   = "frontend-lb"
  shape         = "flexible"
  subnet_ids    = [oci_core_subnet.access_subnet.id]

  shape_details {
    minimum_bandwidth_in_mbps = 10
    maximum_bandwidth_in_mbps = 100
  }

  is_private = false # Set to true for internal LB
}

resource "oci_load_balancer_listener" "frontend_listener" {
  load_balancer_id        = oci_load_balancer_load_balancer.frontend_lb.id
  name                    = "frontend-listener"
  default_backend_set_name = oci_load_balancer_backend_set.frontend_bs.name
  port                    = 80
  protocol                = "HTTP"
}

resource "oci_load_balancer_backend_set" "frontend_bs" {
  name             = "frontend-backendset"
  load_balancer_id = oci_load_balancer_load_balancer.frontend_lb.id
  policy           = "ROUND_ROBIN"

  health_checker {
    protocol = "TCP"
    port     = 80
  }
}


resource "oci_load_balancer_backend" "backend_lb1" {
  load_balancer_id = oci_load_balancer_load_balancer.frontend_lb.id
  backendset_name = oci_load_balancer_backend_set.frontend_bs.name
  ip_address       = oci_load_balancer_load_balancer.backend_lb1.ip_addresses[0]   # IP address obtained from locals variable
  port             = 80
  weight           = 1
  backup           = false
  drain            = false
  offline          = false
}

resource "oci_load_balancer_backend" "backend_lb2" {
  load_balancer_id = oci_load_balancer_load_balancer.frontend_lb.id
  backendset_name = oci_load_balancer_backend_set.frontend_bs.name
  ip_address       = oci_load_balancer_load_balancer.backend_lb2.ip_addresses[0]    # IP address obtained from locals variable
  port             = 80
  weight           = 1
  backup           = false
  drain            = false
  offline          = false
}

