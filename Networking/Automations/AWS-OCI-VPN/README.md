# 🌐 OCI ↔ AWS Site-to-Site VPN Setup using Terraform

This Terraform configuration deploys a **Site-to-Site VPN** connection between **Oracle Cloud Infrastructure (OCI)** and **Amazon Web Services (AWS)**.

---

## 🔍 Summary

This code automates the provisioning of the following infrastructure components through modular Terraform configuration:

* **OCI**: VCN, DRG, DRG Attachment, CPE, IPSEC Connection
* **AWS**: VPC, VPN Gateway, Gateway Attachment, Customer Gateway, and VPN Connection

---

## 📁 Project Structure

```
.
├── main.tf
├── provider.tf
├── var.tf
├── terraform.tfvars
├── modules/
│   ├── aws/
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── oci/
│       ├── main.tf
│       ├── provider.tf
│       ├── variables.tf
│       └── outputs.tf
└── README.md
```

**File Descriptions:**

* **main.tf** – Root Terraform file orchestrating module calls for AWS and OCI.
* **provider.tf** – Configures both AWS and OCI providers.
* **var.tf** – Centralized variable definitions for shared parameters.
* **modules/aws** – Contains all AWS-related Terraform resources (VPC, VPN gateway, customer gateway, etc.).
* **modules/oci** – Contains all OCI-related Terraform resources (VCN, DRG, IPSec connection, CPE, etc.).

---

## ⚙️ Prerequisites

Before running Terraform, ensure you have the following:

### **OCI Requirements**

* OCI account with permissions for networking and compute
* Terraform CLI ≥ **1.3.0**
* OCI API key configured for CLI or Terraform provider
* OCIDs for tenancy, compartment, and desired region

### **AWS Requirements**

* AWS account with IAM permissions for networking and compute
* Terraform CLI ≥ **1.5.0**

---

## 🔐 Credentials

### **AWS Environment Variables**

```bash
export AWS_ACCESS_KEY="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_SESSION_TOKEN="your-session-token"
export AWS_DEFAULT_REGION="us-east-1"
```

### **OCI Variables**

```hcl
tenancy        = "<tenancy_ocid>"
user           = "<user_ocid>"
fingerprint    = "<api_fingerprint>"
key_file       = "<path_to_private_key>"
region         = "<oci-region>"
```

---

## 🔧 Configure Terraform Variables

Define all required variables in **`terraform.tfvars`**:

```hcl
region                  = "us-ashburn-1"                         # Your OCI region
compartment_id          = "ocid1.compartment.oc1..xxxxxx"        # Your OCI compartment OCID
tenancy_ocid            = "ocid1.tenancy.oc1..xxxxxx"            # Your OCI tenancy OCID
user_ocid               = "ocid1.user.oc1..xxxxxx"               # Your OCI user OCID
fingerprint             = "your-api-key-fingerprint"             # Your OCI API key fingerprint
private_key_path        = "/path/to/your/private_key.pem"        # Path to your private key

oci_tunnel_ip           = "1.1.1.1"                              # Placeholder IP (to be updated)
aws_access_key          = "xxxxxxxx"
aws_secret_key          = "xxxxxxxxx"
aws_token               = "xxxxx"

vcn_cidr                = "10.0.0.0/23"
vpc_cidr                = "10.1.0.0/16"
```

---

## 🚀 Deployment Steps

### **1️⃣ Initialize Terraform**

Download necessary providers and prepare the working directory:

```bash
terraform init
```

### **2️⃣ Review the Plan**

Preview the infrastructure changes:

```bash
terraform plan
```

### **3️⃣ Apply the Configuration**

Apply the configuration to deploy OCI and AWS resources:

```bash
terraform apply
```

Type **`yes`** when prompted to confirm.

---

## ✅ Verify Deployment

Once deployment completes, verify resource creation:

* **OCI:** VCN, DRG, DRG Attachment, CPE, and IPSEC Connection
* **AWS:** VPC, VPN Gateway, Gateway Attachment, Customer Gateway, and VPN Connection

---

## ⚠️ Important Final Step

This Terraform setup creates **AWS resources first**, followed by **OCI resources** to ensure dependencies (like the CPE in OCI) are properly configured.
Because AWS resources are created before OCI, a **placeholder IP** is used for the OCI tunnel in AWS.

To finalize the configuration:

1. In the OCI Console, navigate to the **IPSec Connection** page.
2. Copy the **Tunnel 1 Public IP address**.
3. Update the `oci_tunnel_ip` in `terraform.tfvars` with this value.
4. Reapply the configuration:

   ```bash
   terraform apply
   ```

   This will update the AWS CPE with the correct IP and establish the VPN tunnel.

---

## 🧹 Cleanup

To destroy all created resources:

```bash
terraform destroy -auto-approve
```

---
