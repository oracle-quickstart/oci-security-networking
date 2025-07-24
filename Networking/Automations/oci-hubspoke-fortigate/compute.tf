resource "oci_core_instance" "spoke_vm" {
    depends_on = [ oci_core_subnet.public_subnet ]
  for_each = var.spoke_instances
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_id
  shape               = var.spoke_vm_compute_shape
  shape_config {
    ocpus         = 1
    memory_in_gbs = 12
  }
  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.InstanceImageOCID.images[0].id
  }
  display_name = each.value.display_name
  create_vnic_details {
    assign_public_ip = each.value.subnet_type == "public" ? true : false
    subnet_id        = each.value.subnet_type == "public" ? oci_core_subnet.public_subnet[each.key].id : oci_core_subnet.private_subnet[each.key].id
  }
  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
  }
  preserve_boot_volume = false
}
data "oci_identity_availability_domains" "ads" {
    compartment_id = var.compartment_id
}
data "oci_core_images" "InstanceImageOCID" {
  compartment_id = var.compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = "9"
  shape = var.spoke_vm_compute_shape
#filter {
#  name   = "display_name"
#  values = ["^Oracle-\\d+\\.\\d+(?!.*(?:aarch64|GPU)).*$"]
#  regex  = true
#}
}