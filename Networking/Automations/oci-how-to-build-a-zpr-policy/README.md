# OCI VCN with Multiple CIDR Ranges

## Introduction

This stack is designed to deploy a Virtual Cloud Network (VCN) with OCI Zero Trust Packet Routing (ZPR) enabled between two Instances in seperate subnets. OCI Zero Trust Packet Routing enables organizations to set security attributes on resources and write natural language policies that limit network traffic.

## Network Diagram

This code will deploy the scenario from the How to Build a ZPR Policy video: https://www.youtube.com/watch?v=f8utDRAe8ag

## Prerequisites

Following prerequisites are required before deploying this code:
1.	OCI Account.
2.	Target compartment where stack needs to be created and resources need to be deployed.
3.	IAM policies required to provision the resources. Including ZPR Policy (Very Important)
4.	Ensure the service limits allow the deployment of the resources.

## Scope

This code does not deploy:

1.	Compartments and IAM policies.

## Deployment

We will use **Resource Manager** on the OCI console to deploy the stack.

The code contains following configuration:

1. **_main.tf_**: To provision the core resources required: VCN components, Instances, ZPR polices, and related ZPR tags.
2. **_variables.tf_**: To provision the supporting resources required like Region, SSH Public Key, and Instance details respectively. Some variables are configurable such as the region.
3. **_terraform.tfvars_**: Contains variables that will be used for identifying the correct Instance OCID in each OCI Region. This will be passed to the main.tf configuration.

Please follow these instructions to complete the deployment:

1.	Download the configuration of the 3 Terraform files (main.tf, variables.tf, & terraform.tfvars). Add these files into a single ZIP file.
3.	Login to the OCI console and navigate to Developer Services -> Resource Manager -> Stacks.
4.	Create stack by uploading the Terraform ZIP file.
5.	Choose the appropriate compartment. Select Next.
6.  Enter the correct Home Region for your tenancy. This is required for ZPR polices to be applied correctly. You can find your Home Region by selecting the Region drop down in the upper right Region drop-down menu.
7.	Optionally you can also specificy the following:
    **_a._** Availability Domain
    **_b._** Compartment (OCID)
    **_c._** Tenancy (OCID)
    **_d._** VCN DNS Label
    **_e._** Instance Shape
    **_f._** SSH Public Key (for instance login)

    **_Note:_** The current instance image OCID (OCI Linux 8) for every commercial OCI region is visible but unselectable, this info is used by an image variable in the main.tf file to determine the correct image OCID for the Home Region you select.
7.	After creating the stack, click on the stack and click on ‘Plan’ to perform Terraform Plan on the script. This will ensure that you see any errors before applying. You should see a total of 24 resources to add.
8.	Click on ‘Apply’. This step will deploy all the core networking resources including VCNs, subnets, security rules etc..

For verification or testing, you can log into each instance deployed in each of the VCN subnets and test connectivity between them. By default, all subnets will be set to public subnets and will assign public IPs to the VMs deployed.

## Termination

If you want to delete all the resources, you must FIRST retire the ZPR Security Attribute Namespace "src-to-dst". Once completed, you can perform ‘Destroy’ on the stack. 'Destroy' is a one-step operation.