module "aws_vpn" {
  source = "./modules/aws_vpn"
  aws_region     = var.aws_region
  oci_tunnel_ip  = var.oci_tunnel_ip # until OCI built
  aws_access_key     = var.aws_access_key 
  aws_secret_key     = var.aws_secret_key
  aws_token          = var.aws_token
}
module "oci_vpn" {
  source            = "./modules/oci_vpn"
  region            = var.region
  tenancy_ocid      = var.tenancy_ocid
  user_ocid         = var.user_ocid
  fingerprint       = var.fingerprint
  private_key_path  = var.private_key_path
  compartment_id    = var.compartment_id
  vcn_cidr          = var.vcn_cidr

  aws_tunnel1_address = module.aws_vpn.aws_tunnel1_address
  aws_tunnel2_address = module.aws_vpn.aws_tunnel2_address

}