# Copyright (c) 2025, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {
  description = "The tenancy OCID for deployment of IAM resources."
}

variable "user_ocid" {
  default = ""
}
variable "fingerprint" {
  default = ""
}
variable "private_key_path" {
  default = ""
}
variable "private_key_password" {
  default = ""
}

variable "region" {
  description = "The region where the resources are deployed."
}

variable "deploy_compartment" {
  description = "If true, a compartment is deployed for the function. If false, a compartment must be provided in the variable 'existing_compartment_ocid'."
  type        = bool
  default     = true
}

variable "existing_compartment_ocid" {
  description = "The existing compartment OCID where functions are deployed."
  type        = string
  default     = null
}

variable "new_compartment_parent_ocid" {
  description = "The existing compartment OCID chosen as the parent of the new function compartment."
  type        = string
  default     = null
}

variable "new_compartment_name" {
  description = "The new compartment name."
  type        = string
  default     = "function-cmp"
}

variable "deploy_dyn_group_and_policy" {
  description = "If true, a dynamic group and a policy are deployed for the function. Otherwise, it is assumed the required dynamic group and policy have already been created."
  type        = bool
  default     = true
}

variable "dynamic_group_name" {
  description = "Dynamic group name"
  type        = string
  default     = "function-iam-dynamic-group"
}

variable "policy_name" {
  description = "Policy name"
  type        = string
  default     = "function-iam-policy"
}

variable "provide_short_policy_statements" {
  description = "If true, policy statement must be provided in variable 'policy_statements_short'. If false, the policy statements must be provided in the variable 'policy_statements_free'."
  type        = bool
  default     = true
}

variable "policy_statements_short" {
  description = "Policy statements in short form, with only <verb> <resource>. Use this variable for providing <verb> <resource> combinations for creating basic policy statements (allow dynamic-group <dyn-group-name> to <verb> <resource> in compartment <function-compartment>) in the provided function compartment. Within each expanded statement, the grantee is always the dynamic group name provided in the variable 'dynamic_group_name', and the compartment name is then one referred by 'existing_compartment_ocid' or given by 'new_compartment_name' variable."
  type        = string
  default     = "read vaults, use keys, read secret-family"
}

variable "policy_statements_full" {
  description = "Policy statements in full format. Use this variable for providing complex statements when required by the function per OCI requirements. When using this variable, you must provide the full statements, as the module will not make any expansions."
  type        = string
  default     = null
}

variable "policy_compartment_ocid" {
  description = "Policy compartment OCID. By default, the policy is created in the compartment where the function is deployed."
  type        = string
  default     = null
}

variable "ocir_username" {
  description = "OCI registry username"
  type        = string
}

variable "ocir_password" {
  description = "OCI registry password"
  type        = string
  sensitive   = true
}

variable "repository_name" {
  description = "The repository name in OCI registry"
  type        = string
  default     = "terraform-fn-deploy"
}

variable "function_working_dir" {
  description = "Function Working Directory"
  type        = string
  default     = "./src/get-secret"
}

variable "deploy_infra_for_subnet" {
  description = "Deploy infra for subnet, including a VCN, the Subnet itself, a Security List, a Route Table, and a Service Gateway."
  type        = bool
  default     = true
}

variable "existing_vcn_compartment_ocid" {
  description = "Compartment for the existing VCN"
  type        = string
  default     = null
}

variable "existing_vcn_ocid" {
  description = "Existing VCN ID"
  type        = string
  default     = null
}

variable "existing_subnet_ocid" {
  description = "Existing subnet ID"
  type        = string
  default     = null
}

variable "new_vcn_compartment_ocid" {
  description = "Compartment for the new VCN"
  type        = string
  default     = null
}

variable "new_vcn_name" {
  description = "New VCN name"
  type        = string
  default     = "function-vcn"
}

variable "new_vcn_cidr" {
  description = "New VCN CIDR"
  type        = string
  default     = "10.0.0.0/29"
}

variable "new_subnet_name" {
  description = "New Subnet name"
  type        = string
  default     = "function-subnet"
}

variable "new_subnet_cidr" {
  description = "New Subnet CIDR"
  type        = string
  default     = "10.0.0.0/30"
}

variable "function_parameters_json_string" {
  description = "The parameters for the function in a JSON string format, like {\"PARAM_1_NAME\" : \"PARAM_1_VALUE\", \"PARAM_2_NAME\" : \"PARAM_2_VALUE\", ...} (without the escape character)."
  type        = string
  default     = null
}

variable "invoke_function" {
  description = "When true, the function is invoked after deployment."
  type        = bool
  default     = true
}

variable "enable_function_logging" {
  description = "When true, function logging is enabled."
  type        = bool
  default     = true
}
