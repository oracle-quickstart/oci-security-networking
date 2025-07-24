region           = "us-ashburn-1"
tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaaa3qmjxr43tjexx75r6gwk6vjw22ermohbw2vbxyhczksgjir7xdq"
user_ocid        = "ocid1.user.oc1..aaaaaaaag33tshhl6djj3idjjd4l2grvmq76npqpn3o32kzx7awntrwpekqq"
fingerprint      = "85:e6:0a:a4:6e:02:96:93:9e:e3:0a:08:25:83:8b:1e"
private_key_path = "/Users/viashok/Documents/Terraform/%HOMEDRIVE%%HOMEPATH%.ocioci_api_key.pem"
compartment_id = "ocid1.compartment.oc1..aaaaaaaax6o73zzuhj2hysbyqpghgzazkeam6g27vhedfgmtpjqv33s422xa"
ssh_public_key_path = "/Users/viashok/Documents/VMSSHkeypair/testvmkey.pub"
fortigate_image_ocid = "ocid1.image.oc1..aaaaaaaan3lqkje2xpjbakvx642kzmdkudky2wbx3v2j4uizwtvprpa2kelq"


my_public_ip = "122.172.82.56"
hub_vcn_cidr = "10.1.0.0/16"
forti_mgmt_subnet = "10.1.1.0/24"
forti_untrust_subnet = "10.1.2.0/24"
forti_trust_subnet = "10.1.3.0/24"

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