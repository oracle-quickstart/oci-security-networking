## Copyright (c) 2025, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl


# Create VCN

resource "oci_core_virtual_network" "vcn" {
  cidr_block = "10.0.0.0/16"
  compartment_id = var.compartment_ocid
  display_name   = "demovcn"
  dns_label      = "demovcn"
  security_attributes = {                                                               #### ZPR SECURITY ATTRIBUTES APPLIED TO VCN
    "src-to-dst.vcn.mode"  = "enforce"
    "src-to-dst.vcn.value" = "demovcn"

    depends_on = time_sleep.wait_3_minutes.id
  }
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

resource "oci_core_security_list" "sl" {
  compartment_id = var.compartment_ocid
  display_name   = "security-list"
  vcn_id         = oci_core_virtual_network.vcn.id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {

    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = 22
      min = 22
    }
  }

  ingress_security_rules {
    protocol    = "1"
    source      = "0.0.0.0/0"
  }

}

# Create regional subnets in vcn

resource "oci_core_subnet" "subnet1" {
  cidr_block        = var.source-subnet
  display_name      = "source-subnet"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.vcn.id
  dhcp_options_id   = oci_core_virtual_network.vcn.default_dhcp_options_id
  route_table_id    = oci_core_route_table.rt.id
  security_list_ids = [oci_core_security_list.sl.id]
  prohibit_public_ip_on_vnic = false

}

resource "oci_core_subnet" "subnet2" {
  cidr_block        = var.destination-subnet
  display_name      = "destination-subnet"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.vcn.id
  dhcp_options_id   = oci_core_virtual_network.vcn.default_dhcp_options_id
  route_table_id    = oci_core_route_table.rt.id
  security_list_ids = [oci_core_security_list.sl.id]
  prohibit_public_ip_on_vnic = false

}

# Get Oracle Linux Image
data "oci_core_images" "oracle_linux" {
  compartment_id           = var.tenancy_ocid
  operating_system         = "Oracle_Linux"
  operating_system_version = "8"
  shape                    = var.instance_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# Compute Instance in Source Subnet
resource "oci_core_instance" "vm_source" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  display_name        = "source-instance"
  security_attributes = {                                                 #### ZPR SECURITY ATTRIBUTES APPLIED TO SOURCE VNIC
    "src-to-dst.instance.mode"  = "enforce"
    "src-to-dst.instance.value" = "source"

    depends_on = time_sleep.wait_3_minutes.id
  }
  shape               = var.instance_shape
  subnet_id           = oci_core_subnet.subnet1.id
  shape_config {
    ocpus         = 1
    memory_in_gbs = 8
  }
  source_details {
    source_type = "image"
    source_id   = var.instance_image_ocid[var.home_region] ## Link to Official docs https://docs.oracle.com/en-us/iaas/Content/dev/terraform/ref-images.htm
  }
  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}

# Compute Instance in Destination Subnet
resource "oci_core_instance" "vm_destination" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  display_name        = "destination-instance"
  security_attributes = {                                                    #### ZPR SECURITY ATTRIBUTES APPLIED TO DESTINATION VNIC
    "src-to-dst.instance.mode"  = "enforce"
    "src-to-dst.instance.value" = "destination"

    depends_on = time_sleep.wait_3_minutes.id
  }
  shape               = var.instance_shape
  subnet_id           = oci_core_subnet.subnet2.id
  shape_config {
    ocpus         = 1
    memory_in_gbs = 8
  }
  source_details {
    source_type = "image"
    source_id   = var.instance_image_ocid[var.home_region] ## Link to Official docs https://docs.oracle.com/en-us/iaas/Content/dev/terraform/ref-images.htm
  }
  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}

#resource "oci_zpr_configuration" "this" {                                     #### ENABLES ZPR CONFIG IN TENANCY -- UNCOMMENT TO SET ACTIVE
#  compartment_id = var.tenancy_ocid
#  zpr_status = "ENABLED"
#}

resource "oci_security_attribute_security_attribute_namespace" "src-to-dst-instance-terraform" {
    compartment_id   = var.compartment_ocid
    description      = "Namespace for Source Instance to Destination Instance Connectivity"
    name             = "src-to-dst"
}

resource "oci_security_attribute_security_attribute" "instance" {
    description                         = "Security attribute for instances."
    name                                = "instance"
    security_attribute_namespace_id     = oci_security_attribute_security_attribute_namespace.src-to-dst-instance-terraform.id
    validator {
      validator_type                      = "ENUM"
      values                              = ["source", "destination"]
    }
}

resource "oci_security_attribute_security_attribute" "vcn" {
    description                         = "Security attribute for VCN."
    name                                = "vcn"
    security_attribute_namespace_id     = oci_security_attribute_security_attribute_namespace.src-to-dst-instance-terraform.id
}


resource "oci_zpr_zpr_policy" "src-to-dst-instance-terraform" {            #### ZPR POLICIES CAN ONLY BE DEPLOYED IN THE HOME REGION
  compartment_id      = var.tenancy_ocid
  description         = "access-source-to-destination-instance-terraform"
  name = "src-to-dst-instance"
  statements = [
    "in src-to-dst.vcn:demovcn VCN allow '0.0.0.0/0' to connect to src-to-dst.instance:source endpoints with protocol='tcp/22'",
    "in src-to-dst.vcn:demovcn VCN allow '0.0.0.0/0' to connect to src-to-dst.instance:destination endpoints with protocol='tcp/22'",
    "in src-to-dst.vcn:demovcn VCN allow src-to-dst.instance:source endpoints to connect to src-to-dst.instance:destination endpoints",
    "in src-to-dst.vcn:demovcn VCN allow src-to-dst.instance:destination endpoints to connect to src-to-dst.instance:source endpoints",
  ]
}

resource "time_sleep" "wait_3_minutes" {
  create_duration = "180s"
}


# Get Availability Domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_ocid
}