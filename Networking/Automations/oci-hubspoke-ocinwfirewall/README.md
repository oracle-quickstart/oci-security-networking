**OCI Hub and Spoke Network Firewall Architecture**

This Terraform configuration deploys a Hub-and-Spoke architecture in
Oracle Cloud Infrastructure (OCI) with a network firewall for traffic
inspection between the hubs and spokes.

**Summary**

This Terraform code automates the deployment of the following resources
in OCI:

- **VCN (Virtual Cloud Network)** with both public and private subnets.

- **Security Lists** for controlling traffic between spokes.

- **Route Tables** to direct traffic appropriately within the VCNs.

- **Compute Instances (VMs)** in the spoke VCNs, in selected **public** or **private** subnet

- **Dynamic Routing Gateway (DRG)** and **attachments** for connecting the
  hub VCN with the spoke VCNs.

- **OCI Network Firewall** for traffic inspection

- **Firewall Policies** a sample firewall policy to allow  all traffic between networks.

The architecture is designed for secure, scalable communication between
different OCI VCNs, and it can be easily extended to more spoke networks
by modifying the variables.

**Steps to Use the Code**

**1. Prerequisites**

Ensure you have the following in place:

- An Oracle Cloud account with the necessary privileges to create
  network and compute resources.

- **Terraform** installed on your local machine (version \>= 1.3.0).

- Access to an **OCI API key** for Terraform authentication.

- An **OCI Compartment ID** and other required values (OCIDs, VCN CIDR
  blocks, etc.).

**2. Configure Terraform Variables**

In the terraform.tfvars file, you need to define values for the
following variables:

```
region                  = "us-phoenix-1"                         # Your OCI region
compartment_id          = "ocid1.compartment.oc1..xxxxxx"        # Your OCI compartment OCID
tenancy_ocid            = "ocid1.tenancy.oc1..xxxxxx"            # Your OCI tenancy OCID
user_ocid               = "ocid1.user.oc1..xxxxxx"               # Your OCI user OCID
fingerprint             = "your-api-key-fingerprint"             # Your OCI API key fingerprint
private_key_path        = "/path/to/your/private_key.pem"        # Path to your private key
ssh_public_key_path     = "/path/to/your/ssh_public_key.pub"     # Path to your SSH public key
my_public_ip            = "your-public-ip"                       # Your public IP (for SSH access)
hub_vcn_cidr            = "10.0.0.0/16"                          # CIDR for the Hub VCN
hub_vcn_pub_subnet      = "10.0.1.0/24"                          # CIDR for the Hub public subnet

# A map of compute instances to be provisioned in each spoke network. Each entry contains:
# - `subnet_type`: Specifies whether the instance is in a public or private subnet.
# - `display_name`: The display name for the compute instance.

spoke_instances = {
  spoke01 = {
    subnet_type   = "public"
    display_name = "VM_Spoke01"
  },
  spoke02 = {
    subnet_type   = "private"
    display_name = "VM_Spoke02"
  }
}

# A map defining spoke VCN configurations, where each key represents a spoke identifier. Each entry includes:
# - `cidr_block`: The CIDR block for the VCN.
# - `public_subnet_cidr`: The CIDR block for the public subnet.
# - `private_subnet_cidr`: The CIDR block for the private subnet.
# - `dns_label`: The DNS label for the VCN.

spoke_vcn = {
  spoke1 = {
    cidr_block           = "192.168.1.0/24"
    public_subnet_cidr   = "192.168.1.0/26"
    private_subnet_cidr  = "192.168.1.64/26"
    dns_label            = "spoke1"
  }
  spoke2 = {
    cidr_block           = "192.168.2.0/24"
    public_subnet_cidr   = "192.168.2.0/26"
    private_subnet_cidr  = "192.168.2.64/26"
    dns_label            = "spoke2"
  }
}
```

Adjust the above configuration according to your network architecture
needs.

**3. Initialize Terraform**

Once the variables are configured, initialize Terraform to download the
necessary providers:
```
terraform init
```
**4. Review the Plan**

Run the following command to see the execution plan and verify that the
resources will be created as expected:

```
terraform plan
```
**5. Apply the Configuration**

If everything looks good, apply the configuration to create the
resources in OCI:
```
terraform apply
```
Confirm the action by typing yes when prompted.

**6. Verify the Deployment**

Once the apply is complete, verify that the resources have been created
correctly in OCI:

- Check the **VCNs**, **subnets**, and **compute instances** in the OCI
  Console.

- Verify that the **Network Firewall** is deployed and active.

**7. Using OCI Resource Manager (Optional)**

You can use **OCI Resource Manager** to manage your infrastructure as
code. To do this:

1.  Navigate to the **Resource Manager** service in the OCI console.

2.  Create a **stack** and upload the Terraform configuration files
    (including main.tf, compute.tf, etc.).

3.  Run the stack to create the resources in OCI.

This allows you to manage and maintain the infrastructure from the OCI
Console instead of running Terraform locally.

**File Overview**

- **main.tf**: Contains resources for DRG (Dynamic Routing Gateway),
  route tables, DRG attachments, and VCNs for the hub and spoke
  networks.

- **compute.tf**: Defines the compute instances (VMs) for each spoke,
  including the configuration for the source image and the compute
  shape.

- **firewall.tf**: Configures the OCI Network Firewall, including
  firewall policies and security rules to inspect and filter traffic.

- **spoke.tf**: Defines resources for each spoke VCN, including subnets
  (public and private), route tables, security lists, and optional NAT
  gateways.

- **var.tf**: Defines the variables used across the Terraform
  configuration, including details about the region, compartment, and
  networking information.

**Additional Notes**

- This configuration assumes that you have the appropriate network
  security policies and key management in place in your OCI tenancy.

- The oci_network_firewall_network_firewall_policy_security_rule
  resource has a rule that allows all traffic between the hub and spoke
  VCNs. You can customize this as per your security requirements.

- The compute instances in the spoke VCNs are configured with SSH
  access. Ensure that the SSH key paths are correct.

- The infrastructure created can be scaled by adding more entries to the
  spoke_vcn map and adjusting the spoke_instances map accordingly.

**Conclusion**

This Terraform code provides a scalable and secure hub-and-spoke network
architecture in OCI, complete with network traffic inspection via OCI\'s
Network Firewall. By following these steps and customizing the
variables, you can deploy a secure and fully operational network in OCI.
