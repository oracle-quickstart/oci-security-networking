resource "oci_load_balancer_load_balancer" "fusion_print_load_balancer" {
    #Required
    compartment_id = var.compartment_ocid
    display_name = var.label_prefix == "none" ? var.load_balancer_display_name : "${var.label_prefix}_${var.load_balancer_display_name}"
    shape = "flexible"
    subnet_ids = [oci_core_subnet.vcn_subnet.id]

    #Optional
    ip_mode = "IPV4"
    is_private = "false"
    network_security_group_ids = [oci_core_network_security_group.flb_network_security_group.id]
    shape_details {
        #Required
        maximum_bandwidth_in_mbps = var.load_balancer_shape_details_maximum_bandwidth_in_mbps
        minimum_bandwidth_in_mbps = var.load_balancer_shape_details_minimum_bandwidth_in_mbps
    }
}

resource "oci_load_balancer_backend_set" "fusion_backend_set" {
    #Required
    health_checker {
        #Required
        protocol = "TCP"

        #Optional
        port = "443"
    }
    load_balancer_id = oci_load_balancer_load_balancer.fusion_print_load_balancer.id
    name = "On_Prem_Printer_Backend_Set"
    policy = "ROUND_ROBIN"    
}

resource "oci_load_balancer_backend" "backend" {
    #Required
    backendset_name = oci_load_balancer_backend_set.fusion_backend_set.name
    ip_address = var.on_prem_printer_ip
    load_balancer_id = oci_load_balancer_load_balancer.fusion_print_load_balancer.id
    port = "443"
}

resource "oci_load_balancer_listener" "listener" {
    #Required
    default_backend_set_name = oci_load_balancer_backend_set.fusion_backend_set.name
    load_balancer_id = oci_load_balancer_load_balancer.fusion_print_load_balancer.id
    name = "Fusion_Print_Listener"
    port = "443"
    protocol = "TCP"
}