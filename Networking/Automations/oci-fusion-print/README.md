# oci-fusion-print

The OCI Terraform stack for Fusion Printing allows you to create and provision OCI infrastructure components required to print security from Fusion using OCI.  

It creates the following resources outlined in this [blog] and [video] 

* VCN with a CIDR block, public subnet, and route table
* Internet gateway
* Dynamic routing gateway
* Public flexible load balancer with a single backend set and a single backend
* Network security group with appropriate rules for Fusion printing

## Prerequisites and postrequisites

There are some tasks outside of OCI and this Terraform stack that you will need in order for this solution to work.  Those tasks are outlined below, please see the [blog] and [video] 

* FastConnect or IPSec VPN Tunnel from OCI to on-premise
* Printer or print server on-premise
* Public CIDR from the region where your Fusion applications are hosted
* External/public DNS record that resolves to the public IP address of the Flexible Load Balancer

## Resource Manager Deployment

This stack uses [OCI Resource Manager](https://docs.cloud.oracle.com/iaas/Content/ResourceManager/Concepts/resourcemanager.htm) to make deployment easy, sign up for an [OCI account](https://cloud.oracle.com/en_US/tryit) if you don't have one, and just click the button below:

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/benwoltz/oci-fusion-print/archive/master.zip)

After logging into the console you'll be taken through the same steps described below:

Step 1 - Check the "I have reviewed and accept the Oracle Terms of Use" checkbox and optionally provide a name for this stack. 
![Stack Step 1](images/Stack%201.png)

Step 2 - Select the compartment and Terraform version and click "Next"
![Stack Step 2](images/Stack%202.png)

Step 3 - Fill out all variables listed (All are required but some have default values provided) and click "Next"
![Stacke Step 3](images/Stack%203.png)

Step 4 - Review the information and click "Create"


## Related Documentation, Blog

* [Oracle Cloud Infrastructure Documentation][oci_documentation]
* [Terraform OCI Provider Documentation][terraform_oci]
* [Secure On-Premise Printing From Oracle Fusion BI Publisher using OCI Blog][blog]
* [Secure On-Premise Printing From Oracle Fusion BI Publisher using OCI Video][video]


<!-- Links reference section -->
[changelog]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/CHANGELOG.adoc
[contributing]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/CONTRIBUTING.adoc
[contributors]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/CONTRIBUTORS.adoc
[docs]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/tree/main/docs

[blog]: https://www.ateam-oracle.com/post/using-oci-for-secure-on-prem-printing-from-oracle-fusion-bi-publisher
[video]: https://www.youtube.com/watch?v=6xJo-njF1r0

[oci]: https://cloud.oracle.com/cloud-infrastructure
[oci_documentation]: https://docs.cloud.oracle.com/iaas/Content/home.htm

[oracle]: https://www.oracle.com
[prerequisites]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/prerequisites.adoc

[quickstart]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/quickstart.adoc
[repo]: https://github.com/oracle-quickstart/oci-fusion-print
[terraform]: https://www.terraform.io
[terraform_oci]: https://www.terraform.io/docs/providers/oci/index.html
<!-- Links reference section -->