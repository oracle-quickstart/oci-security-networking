resource "oci_core_instance" "palo_alto" {
  compartment_id = var.compartment_id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  shape = "VM.Optimized3.Flex" # Example shape, adjust as needed
  display_name = "palo_alto_vm"

  shape_config {
    memory_in_gbs = 16
    ocpus = 4
  }

  create_vnic_details {
    subnet_id = oci_core_subnet.pan_mgmt_subnet.id
    assign_public_ip = true
    display_name = "palo_alto_vnic"
  }

  source_details {
    source_type = "image"
    source_id   = var.palo_alto_image_ocid
    boot_volume_size_in_gbs = 100
  }

  metadata = {
    ssh_authorized_keys = file("/Users/viashok/PAkey.pub")
  }


}

#attach untrust and trust
resource "oci_core_vnic_attachment" "untrust_vnic" {
  instance_id          = oci_core_instance.palo_alto.id
  create_vnic_details {
    subnet_id         = oci_core_subnet.pan_untrust_subnet.id
    display_name      = "untrust_vnic"
    assign_public_ip  = false
    skip_source_dest_check = true
  }
}

resource "oci_core_vnic_attachment" "trust_vnic" {
  instance_id          = oci_core_instance.palo_alto.id
  create_vnic_details {
    subnet_id         = oci_core_subnet.pan_trust_subnet.id
    display_name      = "trust_vnic"
    assign_public_ip  = false
    skip_source_dest_check = true
  }
}

#Data
data "oci_identity_availability_domains" "fw_ads" {
    compartment_id = var.compartment_id
}