🚀 OCI Hub-and-Spoke using Fortigate firewall 🚀

This Terraform configuration deploys a scalable, modular Hub-and-Spoke network architecture in Oracle Cloud Infrastructure (OCI) with centralized traffic inspection using the Fortigate Firewall.

🔍 Summary
This code automates the provisioning of:

✅ Hub VCN with centralized Forigate firewall and routing
✅ Spoke VCNs with public and private subnets
✅ Compute Instances in public/private spoke subnets
✅ Security Lists to manage traffic within/between VCNs
✅ DRG and DRG Attachments for full mesh VCN connectivity
✅ Route Tables to steer traffic through the firewall
✅ Fortigate firewall in the hub vcn to inspect traffic between the spokes

🧱 Fully scalable — just update the spoke_vcn and spoke_instances maps to add/remove spokes and compute instances.

🧰 Prerequisites

For Fortigate image, run the following commands in CLI to extract the Image OCID

🟢 vinoth_kum@cloudshell:~ (us-ashburn-1)$ oci compute pic listing list --all --output table --publisher-name "Fortinet, Inc." ----> get the OCID of all the listing IDs available for Fortigate
	
	Pick the right image ID for the bundle you want to work with, then run the following command to get the image ID for all the OS versions

🟢 vinoth_kum@cloudshell:~ (us-ashburn-1)$ oci compute pic version list --listing-id ocid1.appcataloglisting.oc1..aaaaaaaabepjdf2sw2jkr77a7zrbog7ukzxepoexzgkoyvbw2j2jn7l4y7lq --all --output table

Make sure you have the following:

🟢 OCI account with required permissions for networking and compute
🟢 Terraform CLI ≥ 1.3.0 installed
🟢 OCI API key configured for CLI or Terraform provider
🟢 OCIDs for tenancy, compartment, and desired region

🔧 Configure Terraform Variables

In the terraform.tfvars file, you need to define values for the following variables:

region = "us-ashburn-1" # Your OCI region
compartment_id = "ocid1.compartment.oc1..xxxxxx" # Your OCI compartment OCID
tenancy_ocid = "ocid1.tenancy.oc1..xxxxxx" # Your OCI tenancy OCID
user_ocid = "ocid1.user.oc1..xxxxxx" # Your OCI user OCID
fingerprint = "your-api-key-fingerprint" # Your OCI API key fingerprint
private_key_path = "/path/to/your/private_key.pem" # Path to your private key
ssh_public_key_path = "/path/to/your/ssh_public_key.pub" # Path to your SSH public key
fortigate_image_ocid = "ocid1.image.oc1..xxxxxxxx" # Image ID of the fortigate firewall VM
my_public_ip = "your-public-ip" # Your public IP (for SSH access)
hub_vcn_cidr = "10.0.0.0/16" # CIDR for the Hub VCN
hub_vcn_pub_subnet = "10.0.1.0/24" # CIDR for the Hub public subnet

# A map of compute instances to be provisioned in each spoke network. Each entry contains:
# - `subnet_type`: Specifies whether the instance is in a public or private subnet.
# - `display_name`: The display name for the compute instance.
spoke_instances = {
 spoke01 = {
 subnet_type = "public"
 display_name = "VM_Spoke01"
 },
 spoke02 = {
 subnet_type = "private"
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
 cidr_block = "192.168.1.0/24"
 public_subnet_cidr = "192.168.1.0/26"
 private_subnet_cidr = "192.168.1.64/26"
 dns_label = "spoke1"
 }
 spoke2 = {
 cidr_block = "192.168.2.0/24"
 public_subnet_cidr = "192.168.2.0/26"
 private_subnet_cidr = "192.168.2.64/26"
 dns_label = "spoke2"
 }
}

Adjust the above configuration according to your network architecture needs.

⚙️ How to Use

1️⃣ Initialize Terraform

Once the variables are configured, initialize Terraform to download the necessary providers:

terraform init

2️⃣ Review the Plan

Run the following command to see the execution plan and verify that the resources will be created as expected:

terraform plan

3️⃣ Apply the Configuration

If everything looks good, apply the configuration to create the resources in OCI:

terraform apply

Confirm the action by typing yes when prompted.

✅ Verify Deployment

Once the apply is complete, verify that the resources have been created correctly in OCI:
Check VCNs, subnets, and compute instances in the OCI Console
Ensure the OCI Network Firewall is active and inspecting traffic
Confirm DRG connectivity between hub and spokes

☁️ (Optional) OCI Resource Manager
You can use OCI Resource Manager to manage your infrastructure as code. To do this:
Navigate to the Resource Manager service in the OCI console.
Create a stack and upload the Terraform configuration files (including main.tf, compute.tf, etc.).
Run the stack to create the resources in OCI.
This allows you to manage and maintain the infrastructure from the OCI Console instead of running Terraform locally.

📁 File Overview
main.tf: Contains resources for DRG (Dynamic Routing Gateway), route tables, DRG attachments, and VCNs for the hub and spoke networks.
compute.tf: Defines the compute instances (VMs) for each spoke, including the configuration for the source image and the compute shape.
firewall.tf: Configures the Fortigate Firewall, including all three VNICs (MGMT, Trust & Untrust) in respective subnets.
spoke.tf: Defines resources for each spoke VCN, including subnets (public and private), route tables, security lists, and optional NAT gateways.
var.tf: Defines the variables used across the Terraform configuration, including details about the region, compartment, and networking information.

Additional Notes

This configuration assumes that you have the appropriate network security policies and key management in place in your OCI tenancy.
The compute instances in the spoke VCNs are configured with SSH access. Ensure that the SSH key paths are correct.
The infrastructure created can be scaled by adding more entries to the spoke_vcn map and adjusting the spoke_instances map accordingly.

🧼 Cleanup

To destroy all deployed resources:

terraform destroy
