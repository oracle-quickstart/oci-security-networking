region           = "ap-singapore-1"
tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaaa3qmjxr43tjexx75r6gwk6vjw22ermohbw2vbxyhczksgjir7xdq"
user_ocid        = "ocid1.user.oc1..aaaaaaaat42ko7hdurycoonyqvgliyat743lyv6yapswqb5uc3tmumilvrvq"
fingerprint      = "0b:16:e2:5b:49:ed:56:e2:91:ed:2b:a9:83:ee:e7:a1"
private_key_path = "/Users/sujitn/Downloads/sujit.s.nair@oracle.com_2024-12-02T14_17_26.015Z.pem"
compartment_id = "ocid1.compartment.oc1..aaaaaaaavxmj7h6kwjg2rxmpnn6b677jsljm2fwfhbjqgyk5igkx4o6rdiba"
ssh_public_key_path = "/Users/sujitn/Documents/Projects/TF Workshops/HUB-n-spoke-OCIFW/vmssh.pub"
my_public_ip = "122.172.82.56"
hub_vcn_cidr = "10.1.0.0/16"
hub_vcn_pub_subnet = "10.1.1.0/24"

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
  spoke01 = {
    cidr_block          = "10.10.0.0/23"
    public_subnet_cidr  = "10.10.0.0/24"
    private_subnet_cidr = "10.10.1.0/24"
    dns_label           = "spoke01"
  },
  spoke02 = {
    cidr_block          = "10.20.0.0/23"
    public_subnet_cidr  = "10.20.0.0/24"
    private_subnet_cidr = "10.20.1.0/24"
    dns_label           = "spoke02"
  }
}
