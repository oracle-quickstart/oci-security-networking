region                  = "us-phoenix-1"    # Your OCI region
compartment_id          = "ocid1.compartment.oc1..xxxxxx"    # Your OCI compartment OCID
tenancy_ocid            = "ocid1.tenancy.oc1..xxxxxx"        # Your OCI tenancy OCID
user_ocid               = "ocid1.user.oc1..xxxxxx"            # Your OCI user OCID
fingerprint             = "your-api-key-fingerprint"          # Your OCI API key fingerprint
private_key_path        = "/path/to/your/private_key.pem"    # Path to your private key
ssh_public_key_path     = "/path/to/your/ssh_public_key.pub" # Path to your SSH public key
my_public_ip            = "your-public-ip"                    # Your public IP (for SSH access)
palo_alto_image_ocid = "ocid1.image.oc1..aaaaaaaacg2wfh5nnbpw7qq4aw7gzcjnzto7jo5dihf6ca4nyspzxi7wxdsq"



hub_vcn_cidr = "10.1.0.0/16"
pan_mgmt_subnet = "10.1.1.0/24"
pan_untrust_subnet = "10.1.2.0/24"
pan_trust_subnet = "10.1.3.0/24"


spoke_instances = {
  spoke01 = {
    subnet_type   = "public"
    display_name = "VM_Spoke01"
  },
  spoke02 = {
    subnet_type   = "public"
    display_name = "VM_Spoke02"
  }
}
spoke_vcn = {
  spoke01 = {
    cidr_block          = "10.100.0.0/23"
    public_subnet_cidr  = "10.100.0.0/24"
    private_subnet_cidr = "10.100.1.0/24"
    dns_label           = "spoke01"
  },
  spoke02 = {
    cidr_block          = "10.200.0.0/23"
    public_subnet_cidr  = "10.200.0.0/24"
    private_subnet_cidr = "10.200.1.0/24"
    dns_label           = "spoke02"
  }
}