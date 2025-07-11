
🚀 OCI Hub-and-Spoke using Paloalto Firewall 🚀

This Terraform configuration deploys a scalable, modular **Hub-and-Spoke** network architecture in **Oracle Cloud Infrastructure (OCI)** with centralized traffic inspection using a **Paloalto Firewall**.

---

🔍 Summary

This code automates the provisioning of:

✅ Hub VCN with centralized Paloalto Firewall and routing  
✅ Spoke VCNs with public and private subnets  
✅ Compute Instances in public/private spoke subnets  
✅ Security Lists to manage traffic within/between VCNs  
✅ DRG and DRG Attachments for full mesh VCN connectivity  
✅ Route Tables to steer traffic through the firewall  
✅ Paloalto Firewall in the Hub VCN to inspect traffic between the spokes  

🧱 **Fully scalable** — just update the `spoke_vcn` and `spoke_instances` maps to add or remove spokes and compute instances.

---

🧰 Prerequisites

Before deploying, make sure you have:

- 🟢 An OCI account with permissions for networking and compute
- 🟢 Terraform CLI ≥ `1.3.0` installed
- 🟢 OCI API key configured (for CLI or Terraform provider)
- 🟢 OCIDs for tenancy, compartment, and region

🔍 Getting the Paloalto Image OCID

Use the OCI CLI to find the Paloalto image:

```bash
oci compute pic listing list --all --output table --publisher-name "Palo Alto Networks"
````

Then choose the image ID you want and get the version:

```bash
oci compute pic version list --listing-id <your-pa-listing-id> --all --output table
```

---

🔧 Configure Terraform Variables

Update your `terraform.tfvars` file with the following:

```hcl
region             = "us-ashburn-1"
compartment_id     = "ocid1.compartment.oc1..xxxxxx"
tenancy_ocid       = "ocid1.tenancy.oc1..xxxxxx"
user_ocid          = "ocid1.user.oc1..xxxxxx"
fingerprint        = "your-api-key-fingerprint"
private_key_path   = "/path/to/your/private_key.pem"
ssh_public_key_path = "/path/to/your/ssh_public_key.pub"
my_public_ip       = "your-public-ip"

hub_vcn_cidr       = "10.0.0.0/16"
hub_vcn_pub_subnet = "10.0.1.0/24"

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

Adjust according to your architecture and region.

---

⚙️ How to Use

1️⃣ **Initialize Terraform**

```bash
terraform init
```

2️⃣ **Review the Plan**

```bash
terraform plan
```

3️⃣ **Apply the Configuration**

```bash
terraform apply
```

Confirm with `yes` when prompted.

---

✅ Verify Deployment

After deployment:

* Inspect VCNs, subnets, and compute instances in the **OCI Console**
* Verify **Firewall** is active and routing traffic between spokes
* Check **DRG Attachments** and **route tables** for proper configuration

---

☁️ Optional: OCI Resource Manager

You can also manage the infrastructure via OCI Console:

1. Go to **OCI → Resource Manager**
2. Create a **new stack**, upload the Terraform files
3. **Apply the stack** to create the resources

---

📁 File Overview

| File          | Description                                                              |
| ------------- | ------------------------------------------------------------------------ |
| `main.tf`     | Defines VCNs, DRGs, route tables, and their attachments                  |
| `compute.tf`  | Creates compute instances per spoke and configures their shape/image     |
| `firewall.tf` | Sets up Paloalto Firewall with MGMT, Trust, and Untrust interfaces       |
| `spoke.tf`    | Defines spoke VCNs, subnets, NAT gateways, and related network resources |
| `var.tf`      | Declares input variables used across the Terraform modules               |

---

📝 Additional Notes

* Ensure **SSH key paths** are correct and secure
* All network and firewall configurations follow OCI best practices
* Easily **scale horizontally** by adding entries to `spoke_vcn` and `spoke_instances`

---

🧼 Cleanup

To destroy all created resources:

```bash
terraform destroy
```
