provider "oci" {
   region = "${var.local_region}"
   alias = "local_region"
   tenancy_ocid = "${var.tenancy_ocid}"
}

provider "oci" {
   region = "${var.remote_region}"
   alias = "remote_region"
   tenancy_ocid = "${var.tenancy_ocid}"
}

terraform {
  required_providers {
    oci = {
      source                = "oracle/oci"
     }
  }
}
