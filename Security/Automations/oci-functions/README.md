# Introduction

This Terraform configuration automates the deployment of any [OCI Function](https://docs.oracle.com/en-us/iaas/Content/Functions/Concepts/functionsoverview.htm), covering the following aspects:

1. **IAM compartment, dynamic group and policy**: the configuration supports deploying a new compartment, dynamic group and policy, as well as deploying the function in an existing compartment with no dynamic group and policy. This enables the configuration to be executed for deploying functions in different regions leveraging the same IAM definitions. 
2. **Networking**: the configuration supports deploying the required network infrastructure for the function, including a VCN, a private subnet, routing to Service Gateway and NAT Gateway and the corresponding security rules in a security list. Alternatively, it supports using an existing subnet for the Function. In this case, the subnet must be already satisfy the function connectivity requirements.
3. **Function image build and upload to OCI Registry**: the configuration builds the function image using the *fn* CLI, tags and pushes it to OCI Registry using the *Docker* CLI.
4. **Function Application and Function resources**: the configuration deploys the function application and the function resources, linking the function resource to the function image in OCI Registry.
5. **Logging**: the configuration optionally deploys a log group and a log for the Function. This is essential for debugging purposes.
6. **Function testing**: the configuration optionally invokes the function for testing, with support for passing parameters to the function.

# Requirements

## IAM Permissions

The following permissions are required for the executing user (the user that deploys the Terraform configuration):

1. For deploying the configuration with the IAM resources:

    - Allow group \<group\> to read tenancies in tenancy
    - Allow group \<group\> to manage dynamic-groups in tenancy
    - Allow group \<group\> to manage policies in compartment \<function-compartment\>
    - Allow group \<group\> to manage compartments in compartment \<function-parent-compartment\>

2. For deploying the configuration with the networking infrastructure:

    - Allow group \<group\> to manage virtual-network-family in \<function-compartment\>

3. For deploying the configuration with logging:

    - Allow group \<group\> to manage logging-family in \<function-compartment\>

4. For deploying the function application and the function:

    - Allow group \<group\> to manage functions-family in \<function-compartment\>
    - Allow group \<group\> to manage repos in tenancy

5. For deploying from OCI Cloud Shell:

    - Allow group \<group\> to use cloud-shell in tenancy
    - Allow group \<group\> to use cloud-shell-public-network in tenancy

Or deploy, if you can, as an almighty administrator user.

## Function Source Code

The function source code must be available for the configuration, properly structured according to *fn* requirements. For instance, a Python *fn* function would be comprised of the following files:

- **func.py**: the function source code in Python. Out of box, there's a *handle* method that defines the function entrypoint. This is the method that implements your function.
- **func.yaml**: minimum amount of information required to build and run the function, including the function name, version and entrypoint. The name and version attributes are used by the Terraform automation. In fact, the version attribute is the only value you change to trigger the function code (re)deployment into OCI Registry.
- **requirements.txt**: defines the external packages and dependencies required by the function.

## Environment

The machine where Terraform runs must have *fn* and *docker* (or any compatible tool, like *podman*) available. *fn* is used to build the image, while *docker* (*podman*) is used to tag the image and push it to OCI Registry.

**Tip:** use [OCI Cloud Shell](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/cloudshellintro.htm) as the deployment platform. It has *terraform*, *fn* and *podman* already available.

# Deployment

The button below takes you to OCI Resource Manager service, where you can provide values specific to your requirements and deploy the configuration.

[![Deploy_To_OCI](../../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oracle-quickstart/terraform-oci-fn-deploy/archive/refs/heads/main.zip)

For deploying with Terraform CLI, use the [provided template](./template/). Rename *main.tf.template* to *main.tf*, provide your input parameters in it and run *terraform plan/apply*. Make sure *fn* and *docker/podman* are available. As mentioned, you can use OCI Cloud Shell to deploy. 

**Note:** Cloud Shell terminal runs terraform as the Console connected user. Therefore, input variables *user_ocid*, *fingerprint*, *private_key_path* and *private_key_password* are ignored by Cloud Shell.

Following sections describe the available variables in the configuration: 

## General

- **tenancy_ocid**: the tenancy OCID.
- **user_ocid**: the user OCID that deploys the configuration. This is ignored in OCI Cloud Shell.
- **fingerprint**: the user API key fingerprint. This is ignored in OCI Cloud Shell.
- **private_key_path**: the path to the user API private key. This is ignored in OCI Cloud Shell.
- **private_key_password** the user API private key password, if any. This is ignored in OCI Cloud Shell.
- **region**: the region name where the function, network and logging are deployed. The IAM resources, when requested, are always transparently deployed in the home region. 
    - **Tip**: When deploying the function into multiple regions, set *deploy_compartment* and *deploy_dyn_group_and_policy* variables to false in all deployments, except the first.

## IAM Compartment

- **deploy_compartment**: if true, a compartment is deployed for the function. If false, a compartment must be provided in the variable *existing_compartment_ocid*. 
    - **Tip**: Set to false when using the configuration to deploy the function only. 
- **existing_compartment_ocid**: the existing compartment OCID where the function is deployed.
- **new_compartment_parent_ocid**: the existing compartment OCID chosen as the parent of the new function compartment. Only applicable when *deploy_compartment* is true.
- **new_compartment_name** the new compartment name. Only applicable when *deploy_compartment* is true.

## IAM Dynamic Group and Policy

- **deploy_dyn_group_and_policy**: if true, a dynamic group and a policy are deployed for the function. Otherwise, it is assumed the required dynamic group and policy have already been created. 
    - **Tip**: Set to false when using the configuration to deploy the function only.
- **dynamic_group_name**: the dynamic group name used to execute the function. The function executes under the identity of this dynamic group based on the permissions assigned to it.
- **policy_name**: the policy name.
- **provide_short_policy_statements**: if true, policy statements must be provided in variable *policy_statements_short*. If false, policy statements must be provided in the variable *policy_statements_free*.
- **policy_statements_short**: policy statements in "short" form, provided as a comma-separated list of *\<verb\> \<resource\>* pairs. Use this variable for having the configuration expanding each *\<verb\> \<resource\>* pair into valid basic statement syntax: *allow dynamic-group <dynamic-group-name> to <verb> <resource> in compartment <function-compartment>*. The grantee is always the dynamic group name provided in the variable *dynamic_group_name*, and the compartment name is then one referred by *existing_compartment_ocid* or given by *new_compartment_name* variable. Example: *"read vaults, use keys, read secret-family"*
- **policy_statements_full** policy statements in full format. Use this variable for providing complex statements when required by the function per OCI requirements. When using this variable, you must provide the full statements, as the module will not make any expansions.
- **policy_compartment_ocid** the compartment OCID where the policy is attached. If not provided, the policy is created in the compartment where the function is deployed. 
    - **Tip**: use this to define the policy compartment when the policy statements refer to different compartments.


## Function Networking

- **deploy_infra_for_subnet**: if true, deploys required infrastructure for the function subnet, including a VCN, the Subnet itself (**subnet is private**), a Security List, a Route Table, a Service Gateway and a NAT Gateway. When false, it is assumed that the existing subnet is already properly configured for connecting to Oracle Services Network or to the Internet (if required by the function).
- **new_vcn_compartment_ocid**: the compartment OCID for the new VCN. Only applicable when *deploy_infra_for_subnet* is true.
- **new_vcn_name**: the new VCN name. Only applicable when *deploy_infra_for_subnet* is true.
- **new_vcn_cidr**: the new VCN CIDR block. 
- **new_subnet_name**: the new subnet name. Only applicable when *deploy_infra_for_subnet* is true.
- **new_subnet_cidr**: the new Subnet CIDR. Only applicable when *deploy_infra_for_subnet* is true.
- **existing_vcn_compartment_ocid**: the compartment OCID for the existing VCN. Only applicable when *deploy_infra_for_subnet* is false.
- **existing_vcn_ocid**: the existing VCN OCID. Only applicable when *deploy_infra_for_subnet* is false.
- **existing_subnet_ocid**: the existing subnet OCID. Only applicable when *deploy_infra_for_subnet* is false.

## Function Image, Function Application and Function Resources

- **ocir_username**: the username that pushes the function image to OCI Registry. **It must be allowed to _manage repos in tenancy_**.
- **ocir_password**: the authn token assigned to ocir_username for authenticating to OCI Registry.
- **repository_name**: the repository name in OCI Registry where the function image is pushed into. It is created on the fly.
- **function_working_dir**: the function working directory, where the function artifacts are available (source code, metadata, requirements). It must be accessible by the environment that executes the Terraform configuration, which reads the directory for building the imaging and pushing it to OCI Registry.

**Tip 1**: The function application and function resources are named after the *name* attribute within *func.yaml*, available in *function_working_dir*.

**Tip 2**: When the function source code is updated, make sure to update the *version* attribute within *func.yaml*. **It forces the Terraform configuration to redeploy a new image and push it into OCI Registry.**

## Logging

- **enable_function_logging**: if true, a log group and a log resource are created for the function in the same compartment as the function. Use it for debugging the function.

## Testing the Function

- **function_parameters_map**: the input parameters for the function in a map-like string format, as *"{PARAM_1_NAME = PARAM_1_VALUE, PARAM_2_NAME = PARAM_2_VALUE, ...}"*.
- **invoke_function**: if true, the function is invoked after deployment. Any function outcome is returned in *function_invocation_output* output (and in the *Application Information* tab, when deploying with OCI Resource Manager service).


# Known Issues

1. For pushing the function image as a user not in the Default Identity Domain, ensure you prefix the user name with the tenancy name and the Identity Domain name in *ocir_username* variable: *ocir_username = "\<tenancy-name\>\/<identity-domain-name\>/\<user-name\>"*

2. if you receive the following error when deploying from Mac OS, ensure you have *docker-credential-helper* installed.
```
exit status 1. Output: Error │ saving credentials: error storing credentials - err: exec: "docker-credential-osxkeychain": executable file not found in │ $PATH, out: 
```