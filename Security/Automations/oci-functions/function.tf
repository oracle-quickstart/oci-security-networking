# Copyright (c) 2025, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

resource "oci_functions_application" "this" {
  #Required
  compartment_id = local.function_compartment_ocid
  display_name = "${yamldecode(file("${var.function_working_dir}/func.yaml")).name}-function-application"
  subnet_ids = [var.deploy_infra_for_subnet ? oci_core_subnet.this[0].id : var.existing_subnet_ocid] 
  shape = "GENERIC_ARM"
}

resource "oci_functions_function" "this" {
  depends_on     = [null_resource.deploy_function_image]
  application_id = oci_functions_application.this.id
  display_name   = "${yamldecode(file("${var.function_working_dir}/func.yaml")).name}-function"
  image          = "${local.region_key}.ocir.io/${data.oci_objectstorage_namespace.namespace.namespace}/${var.repository_name}/${yamldecode(file("${var.function_working_dir}/func.yaml")).name}:${yamldecode(file("${var.function_working_dir}/func.yaml")).version}"
  config         = coalesce(var.function_parameters_map,"_EMPTY_") != "_EMPTY_" ? jsondecode(var.function_parameters_map) : null
  memory_in_mbs  = yamldecode(file("${var.function_working_dir}/func.yaml")).memory
}

resource "null_resource" "deploy_function_image" {
  triggers = {
    version = "${yamldecode(file("${var.function_working_dir}/func.yaml")).version}"
  }
  provisioner "local-exec" {
    command = "echo '${var.ocir_password}' |  docker login ${local.region_key}.ocir.io --username ${data.oci_objectstorage_namespace.namespace.namespace}/${var.ocir_username} --password-stdin"
    #command = "docker login ${local.region_key}.ocir.io -u ${data.oci_objectstorage_namespace.namespace.namespace}/${var.ocir_username} -p '${var.ocir_password}'"
  }
  provisioner "local-exec" {
    command     = "fn --verbose build"
    working_dir = var.function_working_dir
  }
  provisioner "local-exec" {
    command     = "IMAGE=$(docker images | grep ${yamldecode(file("${var.function_working_dir}/func.yaml")).name} | awk -F ' ' '{print $3}') ; docker rmi -f $image &> /dev/null ; docker tag $IMAGE ${local.region_key}.ocir.io/${data.oci_objectstorage_namespace.namespace.namespace}/${var.repository_name}/${yamldecode(file("${var.function_working_dir}/func.yaml")).name}:${yamldecode(file("${var.function_working_dir}/func.yaml")).version}"
    working_dir = var.function_working_dir
  }
  provisioner "local-exec" {
    command     = "docker push ${local.region_key}.ocir.io/${data.oci_objectstorage_namespace.namespace.namespace}/${var.repository_name}/${yamldecode(file("${var.function_working_dir}/func.yaml")).name}:${yamldecode(file("${var.function_working_dir}/func.yaml")).version}"
    working_dir = var.function_working_dir
  }
}

resource "null_resource" "wait" {
  depends_on = [oci_functions_function.this]
  count = var.invoke_function ? 1 : 0
  provisioner "local-exec" {
    command = "sleep 30" # Wait some time before invoking the function
  }
}

resource "terraform_data" "current_time" {
  count = var.invoke_function ? 1 : 0
  input = timestamp()
}

resource "oci_functions_invoke_function" "this" {
  depends_on = [null_resource.wait[0]] # Wait some time before invoking the function
  count = var.invoke_function ? 1 : 0
  function_id = oci_functions_function.this.id
  #Optional
  #invoke_function_body = var.invoke_function_invoke_function_body
  #fn_intent = var.invoke_function_fn_intent
  #fn_invoke_type = var.invoke_function_fn_invoke_type
  #is_dry_run = var.invoke_function_is_dry_run
  base64_encode_content = false
  lifecycle {
    replace_triggered_by = [terraform_data.current_time[0]]
  }
}
