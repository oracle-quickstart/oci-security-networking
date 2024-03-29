variable local_region {description = "For example: us-ashburn-1"}
variable remote_region {description = "For example: us-phoenix-1"}
variable compartment_ocid {}
variable tenancy_ocid {}
variable Hub-VCN-CIDR {default="10.0.0.0/24"}
variable Spoke-VCN-1-CIDR {default="10.0.1.0/24"}
variable Spoke-VCN-2-CIDR {default="10.0.2.0/24"}
variable Remote-VCN-CIDR {default="10.0.3.0/24"}
variable Endpoint-Subnet-Hub-VCN-CIDR {default="10.0.0.0/27"}
variable Endpoint-Subnet-Spoke-VCN-1-CIDR {default="10.0.1.0/27"}
variable Endpoint-Subnet-Spoke-VCN-2-CIDR {default="10.0.2.0/27"}
variable Endpoint-Subnet-Remote-VCN-CIDR {default="10.0.3.0/27"}
