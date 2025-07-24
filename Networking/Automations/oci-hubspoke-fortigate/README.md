🚀 OCI Hub-and-Spoke using Fortigate Firewall

This Terraform configuration deploys a scalable, modular **Hub-and-Spoke network architecture** in Oracle Cloud Infrastructure (OCI), with **centralized traffic inspection using the Fortigate Firewall**.

---

🔍 Summary

This code automates the provisioning of:

* ✅ Hub VCN with centralized Fortigate firewall and routing
* ✅ Spoke VCNs with public and private subnets
* ✅ Compute Instances in public/private spoke subnets
* ✅ Security Lists to manage traffic within/between VCNs
* ✅ DRG and DRG Attachments for full mesh VCN connectivity
* ✅ Route Tables to steer traffic through the firewall
* ✅ Fortigate firewall in the Hub VCN to inspect traffic between the spokes

🧱 **Fully scalable** — just update the `spoke_vcn` and `spoke_instances` maps to add or remove spokes and compute instances.


🧰 Prerequisites

To extract the **Fortigate Image OCID**, run the following commands from the OCI CLI:

```bash
oci compute pic listing list --all --output table --publisher-name "Fortinet, Inc."
```

Pick the right image ID for the bundle you want to work with, then run the following command to get the image ID for all the OS versions

```bash
oci compute pic version list --listing-id <listing_id> --all --output table
```

**Make sure you have the following:**

* 🟢 OCI account with required permissions for networking and compute
* 🟢 Terraform CLI ≥ 1.3.0 installed
* 🟢 OCI API key configured (for CLI or Terraform provider)
* 🟢 OCIDs for tenancy, compartment, and desired region

---

🔧 Configure Terraform Variables

In your `terraform.tfvars` file, define the following:

```
region              = "us-ashburn-1"			# Your OCI region
compartment_id      = "ocid1.compartment.oc1..xxxxxx"	# Your OCI compartment OCID
tenancy_ocid        = "ocid1.tenancy.oc1..xxxxxx"	# Your OCI tenancy OCID
user_ocid           = "ocid1.user.oc1..xxxxxx"		# Your OCI user OCID
fingerprint         = "your-api-key-fingerprint"	# Your OCI API key fingerprint
private_key_path    = "/path/to/your/private_key.pem"	# Path to your private key
ssh_public_key_path = "/path/to/your/ssh_public_key.pub"# Path to your SSH public key
fortigate_image_ocid = "ocid1.image.oc1..xxxxxxxx"	# Fortigate Image OCID you extracted from cloud shell
my_public_ip        = "your-public-ip"			# Your public IP (for SSH access)
hub_vcn_cidr        = "10.0.0.0/16"			# CIDR for the Hub VCN
hub_vcn_pub_subnet  = "10.0.1.0/24"			# CIDR for the Hub public subnet
```

# A map of compute instances to be provisioned in each spoke network. Each entry contains:
# - `subnet_type`: Specifies whether the instance is in a public or private subnet.
# - `display_name`: The display name for the compute instance.

```
spoke_instances = {
  spoke01 = {
    subnet_type  = "public"
    display_name = "VM_Spoke01"
  },
  spoke02 = {
    subnet_type  = "private"
    display_name = "VM_Spoke02"
  }
}
```

# A map defining spoke VCN configurations, where each key represents a spoke identifier. Each entry includes:
# - `cidr_block`: The CIDR block for the VCN.
# - `public_subnet_cidr`: The CIDR block for the public subnet.
# - `private_subnet_cidr`: The CIDR block for the private subnet.
# - `dns_label`: The DNS label for the VCN.

```
spoke_vcn = {
  spoke1 = {
    cidr_block         = "192.168.1.0/24"
    public_subnet_cidr = "192.168.1.0/26"
    private_subnet_cidr = "192.168.1.64/26"
    dns_label          = "spoke1"
  },
  spoke2 = {
    cidr_block         = "192.168.2.0/24"
    public_subnet_cidr = "192.168.2.0/26"
    private_subnet_cidr = "192.168.2.64/26"
    dns_label          = "spoke2"
  }
}
```

> Adjust the configuration as needed for your network topology.

---

⚙️ How to Use

1️⃣ Initialize Terraform

```bash
terraform init
```

2️⃣ Review the Plan

```bash
terraform plan
```

3️⃣ Apply the Configuration

```bash
terraform apply
```

> Confirm by typing `yes` when prompted.

---

✅ Verify Deployment in oci console

* Check VCNs, subnets, and compute instances in the OCI Console
* Ensure the Fortigate firewall is up and inspecting traffic
* Validate DRG connectivity between the Hub and Spokes

---

☁️ Optional: Use OCI Resource Manager to manage your infrastructure as code

You can deploy via the OCI Console:

1. Go to **Resource Manager** in OCI
2. Create a new **Stack**
3. Upload all Terraform files (`main.tf`, `compute.tf`, etc.)
4. **Plan** and **Apply** via the console UI

This allows you to manage and maintain the infrastructure from the OCI Console instead of running Terraform locally.

---

📁 File Overview

| File          | Description                                         |
| ------------- | --------------------------------------------------- |
| `main.tf`     | DRG, route tables, VCNs for Hub & Spoke             |
| `compute.tf`  | Compute instances (VMs) for each spoke              |
| `firewall.tf` | Fortigate Firewall and VNICs (MGMT, Trust, Untrust) |
| `spoke.tf`    | Spoke VCNs, subnets, security lists, NAT gateways   |
| `var.tf`      | Variables used throughout the config                |

---

📝 Additional Notes

*This configuration assumes that you have the appropriate network security policies and key management in place in your OCI tenancy.
* Once the firewall is deployed, you can login via GUI and configure as per your requirement.
* Compute instances are SSH-accessible using your provided public key. Ensure that the SSH key paths are correct.
* Scale the setup easily by modifying `spoke_vcn` and `spoke_instances` maps.

---

🧼 Cleanup

To remove all deployed resources:

```bash
terraform destroy
```

---
