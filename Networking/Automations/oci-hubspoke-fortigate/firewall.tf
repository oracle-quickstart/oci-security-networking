resource "oci_core_instance" "forigate" {
  compartment_id = var.compartment_id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  shape = "VM.Standard.E4.Flex" # Example shape, adjust as needed
  display_name = "Fortigate_vm"

  shape_config {
    memory_in_gbs = 16
    ocpus = 4
  }

  create_vnic_details {
    subnet_id = oci_core_subnet.forti_mgmt_subnet.id
    assign_public_ip = true
    display_name = "fortigate_vnic"
  }

  source_details {
    source_type = "image"
    source_id   = var.fortigate_image_ocid
    boot_volume_size_in_gbs = 50
  }

  metadata = {
    ssh_authorized_keys = file("/Users/viashok/PAkey.pub")
  }

}
  
#attach untrust and trust
resource "oci_core_vnic_attachment" "untrust_vnic" {
  instance_id          = oci_core_instance.forigate.id
  create_vnic_details {
    subnet_id         = oci_core_subnet.forti_untrust_subnet.id
    display_name      = "untrust_vnic"
    assign_public_ip  = false
  }
}

resource "oci_core_vnic_attachment" "trust_vnic" {
  instance_id          = oci_core_instance.forigate.id
  create_vnic_details {
    subnet_id         = oci_core_subnet.forti_trust_subnet.id
    display_name      = "trust_vnic"
    assign_public_ip  = false
    skip_source_dest_check = true
  }
}

#Data
data "oci_identity_availability_domains" "fw_ads" {
    compartment_id = var.compartment_id
}