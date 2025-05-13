region                  = "us-phoenix-1"    # Your OCI region
compartment_id          = "ocid1.compartment.oc1..xxxxxx"    # Your OCI compartment OCID
tenancy_ocid            = "ocid1.tenancy.oc1..xxxxxx"        # Your OCI tenancy OCID
user_ocid               = "ocid1.user.oc1..xxxxxx"            # Your OCI user OCID
fingerprint             = "your-api-key-fingerprint"          # Your OCI API key fingerprint
private_key_path        = "/path/to/your/private_key.pem"    # Path to your private key
ssh_public_key_path     = "/path/to/your/ssh_public_key.pub" # Path to your SSH public key
my_public_ip            = "your-public-ip"                    # Your public IP (for SSH access)
hub_vcn_cidr            = "10.0.0.0/16"                       # CIDR for the Hub VCN
hub_vcn_pub_subnet      = "10.0.1.0/24"                       # CIDR for the Hub public subnet

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
