# Copyright (c) 2025, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_objectstorage_namespace" "namespace" {}

data "oci_identity_regions" "these" {}

data "oci_identity_tenancy" "this" {
  tenancy_id = var.tenancy_ocid
}

data "oci_core_services" "these" {}

locals {
  regions_map         = { for r in data.oci_identity_regions.these.regions : r.key => r.name } # All regions indexed by region key.
  regions_map_reverse = { for r in data.oci_identity_regions.these.regions : r.name => r.key } # All regions indexed by region name.
  home_region_key     = data.oci_identity_tenancy.this.home_region_key                         # Home region key obtained from the tenancy data source
  region_key          = lower(local.regions_map_reverse[trimspace(var.region)])                # Region key obtained from the region name

  osn_cidrs = { for s in data.oci_core_services.these.services : s.cidr_block => s.id }

  function_compartment_ocid = var.deploy_compartment ? oci_identity_compartment.this[0].id : var.existing_compartment_ocid
  function_compartment_name = var.deploy_compartment ? oci_identity_compartment.this[0].name : data.oci_identity_compartment.this.name

  function_vcn_compartment_ocid = coalesce(var.new_vcn_compartment_ocid, local.function_compartment_ocid)
}




