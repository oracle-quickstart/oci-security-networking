##### The uncommented variable assignments below are for REQUIRED variables that do NOT have a default value in variables.tf. They must be provided appropriate values.
##### The commented variable assignments are for variables with a default value in variables.tf. For overriding them, uncomment the variable and provide an appropriate value.

# ------------------------------------------------------
# ----- Required Variables
# ----- The below variables do NOT have a default value in variables.tf.  They MUST be provided appropriate values.
# ------------------------------------------------------

# tenancy_ocid = "ocid1.tenancy.oc1..aaaa"
# region = "us-ashburn-1"
# compartment_ocid = "ocid1.compartment.oc1..aaaa"
# user_ocid = "ocid1.user.oc1..aaaa"
# fingerprint          = "a1:c2:"
# private_key_path = "/Users/username/Documents/privatekeypath/privatekey.pem"

# vcn_cidrs = "10.0.0.0/16"
# subnet_cidr_block = "10.0.0.0/24"
# on_prem_printer_ip = "192.168.1.1"
# on_prem_printer_network = "192.168.1.0/24"
# fusion_source_cidr = "147.154.0.0/19"

# ------------------------------------------------------
# ----- Optional Variables
# ----- The below variables have a default value in variables.tf.  For overriding them, uncomment the variable and provide an appropriate value.
# ------------------------------------------------------

# ----- label_prefix variable is used to prefix resource names with.  All resources provisioned will be prefixed with this label variable below.  
# label_prefix = "Fusion_Print"

# vcn_dns_label = "fusionprintvcn"
# vcn_name = "vcn"
# subnet_dns_label = "fusionprintsubnet"
# subnet_name = "Public_Subnet"
# route_table_display_name = "Public Subnet Route Table"
# internet_gateway_display_name = "IGW"
# drg_display_name = "DRG"
# drg_attachment_display_name = "VCN Attachment"
# load_balancer_display_name = "Flexible Load Balancer"


#load_balancer_shape_details_maximum_bandwidth_in_mbps = 10
#load_balancer_shape_details_minimum_bandwidth_in_mbps = 10







