# Copyright (c) 2025, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_core_vcn" "this" {
  count = var.deploy_infra_for_subnet ? 0 : 1
  vcn_id = var.existing_vcn_ocid
}

data "oci_core_subnet" "this" {
  count = var.deploy_infra_for_subnet ? 0 : 1
  subnet_id = var.existing_subnet_ocid
}

output "functions_compartment_id" {
  description = "The OCID of the functions compartment."
  value       = local.function_compartment_ocid
}

output "functions_compartment_name" {
  description = "The name of the function compartment."
  value       = local.function_compartment_name
}

output "functions_dyn_group_name" {
  description = "The name of the dynamic group for functions."
  value       = var.deploy_dyn_group_and_policy ? oci_identity_dynamic_group.this[0].name : null
}

output "functions_dyn_group_id" {
  description = "The OCID of the dynamic group for functions."
  value       = var.deploy_dyn_group_and_policy ? oci_identity_dynamic_group.this[0].id : null
}

output "functions_policy_name" {
  description = "The name of the function policy."
  value       = var.deploy_dyn_group_and_policy ? oci_identity_policy.this[0].name : null
}

output "functions_policy_id" {
  description = "The OCID of the function policy."
  value       = var.deploy_dyn_group_and_policy ? oci_identity_policy.this[0].id : null
}

output "vcn_id" {
  description = "The VCN OCID."
  value       = var.deploy_infra_for_subnet ? oci_core_vcn.this[0].id : data.oci_core_vcn.this[0].id
}

output "vcn_name" {
  description = "The VCN name."
  value       = var.deploy_infra_for_subnet ? oci_core_vcn.this[0].display_name : data.oci_core_vcn.this[0].display_name
}

output "private_subnet_id" {
  description = "The private subnet OCID."
  value       = var.deploy_infra_for_subnet ? oci_core_subnet.this[0].id : data.oci_core_subnet.this[0].id
}

output "private_subnet_name" {
  description = "The private subnet name."
  value       = var.deploy_infra_for_subnet ? oci_core_subnet.this[0].display_name : data.oci_core_subnet.this[0].display_name
}

output "function_application_id" {
  description = "The OCID of the newly created Function application."
  value       = oci_functions_application.this.id
}

output "function_application_name" {
  description = "The name of the newly created Function application."
  value       = oci_functions_application.this.display_name
}

output "function_id" {
  description = "The OCID of the newly created Function."
  value       = oci_functions_function.this.id
}

output "function_name" {
  description = "The name of the newly created Function."
  value       = oci_functions_function.this.display_name
}

output "function_invoke_endpoint" {
  description = "The base https invoke URL to set on a client in order to invoke a function. This URL will never change over the lifetime of the function and can be cached."
  value       = oci_functions_function.this.invoke_endpoint
}

output "function_invocation_test_output" {
  description = "Value of the function invocation test_output."
  value       = var.invoke_function ? oci_functions_invoke_function.this[0].content : null
}

output "function_log_group_id" {
  description = "The OCID of the function log group."
  value       = var.enable_function_logging ? oci_logging_log_group.this[0].id : null
}

output "function_log_group_name" {
  description = "The name of the function log group."
  value       = var.enable_function_logging ? oci_logging_log_group.this[0].display_name : null
}

output "function_log_id" {
  description = "The OCID of the function log."
  value       = var.enable_function_logging ? oci_logging_log.this[0].id : null
}

output "function_log_name" {
  description = "The name of the function log."
  value       = var.enable_function_logging ? oci_logging_log.this[0].display_name : null
}