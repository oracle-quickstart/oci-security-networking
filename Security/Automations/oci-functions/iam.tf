# Copyright (c) 2025, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_identity_compartment" "this" {
  provider = oci.home
  id = local.function_compartment_ocid
}  

resource "oci_identity_compartment" "this" {
  provider = oci.home
  count = var.deploy_compartment ? 1 : 0
  name   = var.new_compartment_name
  description = "Compartment for OCI functions"
  compartment_id = var.new_compartment_parent_ocid
}

resource "oci_identity_dynamic_group" "this" {
  provider = oci.home
  count = var.deploy_dyn_group_and_policy ? 1 : 0
  compartment_id = var.tenancy_ocid
  matching_rule  = "ALL {resource.type = 'fnfunc', resource.compartment.id = '${local.function_compartment_ocid}'}"
  name           = var.dynamic_group_name
  description    = "Dynamic group for OCI functions" 
}

locals {
  policy_statements = var.provide_short_policy_statements == true ? [for p in split(",",var.policy_statements_short) : "Allow dynamic-group ${oci_identity_dynamic_group.this[0].name} to ${trimspace(p)} in compartment ${data.oci_identity_compartment.this.name}"] : [for p in split("\n",var.policy_statements_full) : trimspace(p)]
}

resource "oci_identity_policy" "this" {
  provider = oci.home
  count = var.deploy_dyn_group_and_policy ? 1 : 0
  compartment_id = var.provide_short_policy_statements == true ? local.function_compartment_ocid : coalesce(var.policy_compartment_ocid, local.function_compartment_ocid)
  description    = "Policy required for OCI functions."
  name           = var.policy_name
  statements     = local.policy_statements
}