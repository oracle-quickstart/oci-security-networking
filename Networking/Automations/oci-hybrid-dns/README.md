# OCI Hybrid DNS

## Introduction

This stack is designed to deploy a hybrid DNS solution using OCI's private DNS feature. Hybrid DNS refers to the architecture where DNS zones are hosted both On-Premises and OCI, and conditional forwarding is used to resolve FQDNs accordingly.

## Network Diagram

This code will deploy "Scenario 3" from the blog: https://www.ateam-oracle.com/post/oci-private-dns---common-scenarios
![image](https://github.com/oracle-quickstart/oci-security-networking/assets/42783062/d42845e6-041c-4f82-a8c3-546c3282d08b)

## Prerequisites

Following prerequisites are required before deploying this code:
1.	OCI Account.
2.	Target compartment where stack needs to be created and resources need to be deployed.
3.	IAM policies required to provision the resources.
4.	Ensure the service limits allow the deployment of the resources.

## Scope

This code does not deploy:

1.	Site-to-Site VPN required for hybrid DNS architecture.
2.	Compute instances for verification and testing.
3.	Compartments and IAM policies.


## Deployment

We will use **Resource Manager** on the OCI console to deploy the stack.

The code contains following configuration:

1. **_coreLocal.tf and coreRemote.tf_**: To provision the core resources required like VCNs, route tables, DRG, remote peering etc. for local and remote regions respectively
2. **_dnsLocal.tf and dnsRemote.tf_**: To provision the DNS resources required like endpoints, forwarding rules for local and remote regions respectively
3. **_vars.tf_**: Contains configurable variables and can be modified as per the requirement

The deployment is divided into 2 parts. In the first go, we will deploy core networking components, including VCN, subnets, route rules, security rules, remote peering connection. In the second go, we will deploy the DNS components. The reason for deploying in 2 stages is because the VCN resolver will be created when the VCN is created. However, the creation happens asynchronously and may take longer because it is a background event that needs to run. This creates a dependency on the VCN creation. For this reason, DNS config files (**_dnsLocal.tf and dnsRemote.tf_**) have been commented out for the first run.

Please follow these instructions to complete the deployment:

1.	Download the configuration.
2.	Change the variables like VCN and subnet CIDR blocks as per the requirement in **_vars.tf_** file.
3.	Login to the OCI console and navigate to Developer Services -> Resource Manager -> Stacks.
4.	Create stack by uploading the downloaded and modified terraform folder.
5.	Choose the appropriate compartment.
6.	Enter ‘local_region’ and ‘remote_region’. For example, us-ashburn-1 and us-phoenix-1.
7.	After creating the stack, click on the stack and click on ‘Plan’ to perform Terraform Plan on the script. This will ensure that you see any errors before applying. You should see a total of 24 resources to add.
8.	Click on ‘Apply’. This step will deploy all the core networking resources including VCNs, subnets, security rules etc..
9.	After the core networking is completed, we will deploy DNS components. In the terraform configuration on your local machine, uncomment the DNS configuration code in **_dnsLocal.tf and dnsRemote.tf_** and save the configuration.
10.	Now, go to the existing stack and click on ‘Edit’ -> Edit Stack.
11.	Upload the modified terraform folder and follow the instruction prompts. Region’s information provided earlier remains the same.
12.	After modifying the stack, perform ‘Plan’ and ‘Apply’ as previous. This should deploy 10 DNS resources to the existing deployment.

For verification or testing, you can create 2 compute VMs in each of the VCNs and test the name resolution using ‘nslookup’.
Site-to-Site VPN can be added to test hybrid DNS scenario. Replace the '1.1.1.1' IP address and on premises FQDN in the Hub VCN forwarding rule to the appropriate values.

## Termination

If you want to delete all the resources, you can perform ‘Destroy’ on the stack. This is a one-step operation.

