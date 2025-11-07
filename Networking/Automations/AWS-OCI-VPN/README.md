{\rtf1\ansi\ansicpg1252\cocoartf2822
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fnil\fcharset0 AppleColorEmoji;\f1\froman\fcharset0 Times-Bold;\f2\froman\fcharset0 TimesNewRomanPS-BoldMT;
\f3\froman\fcharset0 Times-Roman;\f4\fmodern\fcharset0 Courier;\f5\fnil\fcharset0 Menlo-Regular;
\f6\fmodern\fcharset0 Courier-Bold;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red109\green109\blue109;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;\cssrgb\c50196\c50196\c50196;}
{\*\listtable{\list\listtemplateid1\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid1\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid1}
{\list\listtemplateid2\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid101\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid2}
{\list\listtemplateid3\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid201\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid3}
{\list\listtemplateid4\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid301\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid4}
{\list\listtemplateid5\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid401\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid5}
{\list\listtemplateid6\listhybrid{\listlevel\levelnfc0\levelnfcn0\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{decimal\}}{\leveltext\leveltemplateid501\'01\'00;}{\levelnumbers\'01;}\fi-360\li720\lin720 }{\listname ;}\listid6}}
{\*\listoverridetable{\listoverride\listid1\listoverridecount0\ls1}{\listoverride\listid2\listoverridecount0\ls2}{\listoverride\listid3\listoverridecount0\ls3}{\listoverride\listid4\listoverridecount0\ls4}{\listoverride\listid5\listoverridecount0\ls5}{\listoverride\listid6\listoverridecount0\ls6}}
\paperw11900\paperh16840\margl1440\margr1440\vieww33700\viewh18680\viewkind0
\deftab720
\pard\pardeftab720\sa321\partightenfactor0

\f0\fs48 \cf0 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 \uc0\u55356 \u57104 
\f1\b  OCI 
\f2 \uc0\u8596 
\f1  AWS Site-to-Site VPN Setup using Terraform\
\pard\pardeftab720\sa240\partightenfactor0

\f3\b0\fs24 \cf0 \strokec2 This Terraform configuration deploys a 
\f1\b Site-to-Site VPN
\f3\b0  connection between 
\f1\b Oracle Cloud Infrastructure (OCI)
\f3\b0  and 
\f1\b Amazon Web Services (AWS)
\f3\b0 .\
\pard\pardeftab720\partightenfactor0
\cf3 \strokec3 \
\pard\pardeftab720\sa298\partightenfactor0

\f0\fs36 \cf0 \strokec2 \uc0\u55357 \u56589 
\f1\b  Summary\
\pard\pardeftab720\sa240\partightenfactor0

\f3\b0\fs24 \cf0 This code automates the provisioning of the following infrastructure components through modular Terraform configuration:\
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa240\partightenfactor0
\ls1\ilvl0
\f1\b \cf0 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 OCI
\f3\b0 : VCN, DRG, DRG Attachment, CPE, IPSEC Connection\
\ls1\ilvl0
\f1\b \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 AWS
\f3\b0 : VPC, VPN Gateway, Gateway Attachment, Customer Gateway, and VPN Connection\
\pard\pardeftab720\partightenfactor0
\cf3 \strokec3 \
\pard\pardeftab720\sa298\partightenfactor0

\f0\fs36 \cf0 \strokec2 \uc0\u55357 \u56513 
\f1\b  Project Structure\
\pard\pardeftab720\partightenfactor0

\f4\b0\fs26 \cf0 .\

\f5 \uc0\u9500 \u9472 \u9472 
\f4  main.tf\

\f5 \uc0\u9500 \u9472 \u9472 
\f4  provider.tf\

\f5 \uc0\u9500 \u9472 \u9472 
\f4  var.tf\

\f5 \uc0\u9500 \u9472 \u9472 
\f4  terraform.tfvars\

\f5 \uc0\u9500 \u9472 \u9472 
\f4  modules/\

\f5 \uc0\u9474 
\f4    
\f5 \uc0\u9500 \u9472 \u9472 
\f4  aws/\

\f5 \uc0\u9474 
\f4    
\f5 \uc0\u9474 
\f4    
\f5 \uc0\u9500 \u9472 \u9472 
\f4  main.tf\

\f5 \uc0\u9474 
\f4    
\f5 \uc0\u9474 
\f4    
\f5 \uc0\u9500 \u9472 \u9472 
\f4  provider.tf\

\f5 \uc0\u9474 
\f4    
\f5 \uc0\u9474 
\f4    
\f5 \uc0\u9500 \u9472 \u9472 
\f4  variables.tf\

\f5 \uc0\u9474 
\f4    
\f5 \uc0\u9474 
\f4    
\f5 \uc0\u9492 \u9472 \u9472 
\f4  outputs.tf\

\f5 \uc0\u9474 
\f4    
\f5 \uc0\u9492 \u9472 \u9472 
\f4  oci/\

\f5 \uc0\u9474 
\f4        
\f5 \uc0\u9500 \u9472 \u9472 
\f4  main.tf\

\f5 \uc0\u9474 
\f4        
\f5 \uc0\u9500 \u9472 \u9472 
\f4  provider.tf\

\f5 \uc0\u9474 
\f4        
\f5 \uc0\u9500 \u9472 \u9472 
\f4  variables.tf\

\f5 \uc0\u9474 
\f4        
\f5 \uc0\u9492 \u9472 \u9472 
\f4  outputs.tf\

\f5 \uc0\u9492 \u9472 \u9472 
\f4  README.md\
\pard\pardeftab720\sa240\partightenfactor0

\f1\b\fs24 \cf0 File Descriptions:
\f3\b0 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa240\partightenfactor0
\ls2\ilvl0
\f1\b \cf0 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 main.tf
\f3\b0  \'96 Root Terraform file orchestrating module calls for AWS and OCI.\
\ls2\ilvl0
\f1\b \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 provider.tf
\f3\b0  \'96 Configures both AWS and OCI providers.\
\ls2\ilvl0
\f1\b \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 var.tf
\f3\b0  \'96 Centralized variable definitions for shared parameters.\
\ls2\ilvl0
\f1\b \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 modules/aws
\f3\b0  \'96 Contains all AWS-related Terraform resources (VPC, VPN gateway, customer gateway, etc.).\
\ls2\ilvl0
\f1\b \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 modules/oci
\f3\b0  \'96 Contains all OCI-related Terraform resources (VCN, DRG, IPSec connection, CPE, etc.).\
\pard\pardeftab720\partightenfactor0
\cf3 \strokec3 \
\pard\pardeftab720\sa298\partightenfactor0

\f0\fs36 \cf0 \strokec2 \uc0\u9881 \u65039 
\f1\b  Prerequisites\
\pard\pardeftab720\sa240\partightenfactor0

\f3\b0\fs24 \cf0 Before running Terraform, ensure you have the following:\
\pard\pardeftab720\sa280\partightenfactor0

\f1\b\fs28 \cf0 OCI Requirements\
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa240\partightenfactor0
\ls3\ilvl0
\f3\b0\fs24 \cf0 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 OCI account with permissions for networking and compute\
\ls3\ilvl0\kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Terraform CLI \uc0\u8805  
\f1\b 1.3.0
\f3\b0 \
\ls3\ilvl0\kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 OCI API key configured for CLI or Terraform provider\
\ls3\ilvl0\kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 OCIDs for tenancy, compartment, and desired region\
\pard\pardeftab720\sa280\partightenfactor0

\f1\b\fs28 \cf0 \strokec2 AWS Requirements\
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa240\partightenfactor0
\ls4\ilvl0
\f3\b0\fs24 \cf0 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 AWS account with IAM permissions for networking and compute\
\ls4\ilvl0\kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Terraform CLI \uc0\u8805  
\f1\b 1.5.0
\f3\b0 \
\pard\pardeftab720\partightenfactor0
\cf3 \strokec3 \
\pard\pardeftab720\sa298\partightenfactor0

\f0\fs36 \cf0 \strokec2 \uc0\u55357 \u56592 
\f1\b  Credentials\
\pard\pardeftab720\sa280\partightenfactor0

\fs28 \cf0 AWS Environment Variables\
\pard\pardeftab720\partightenfactor0

\f4\b0\fs26 \cf0 export AWS_ACCESS_KEY="your-access-key"\
export AWS_SECRET_ACCESS_KEY="your-secret-key"\
export AWS_SESSION_TOKEN="your-session-token"\
export AWS_DEFAULT_REGION="us-east-1"\
\pard\pardeftab720\sa280\partightenfactor0

\f1\b\fs28 \cf0 OCI Variables\
\pard\pardeftab720\partightenfactor0

\f4\b0\fs26 \cf0 tenancy        = "<tenancy_ocid>"\
user           = "<user_ocid>"\
fingerprint    = "<api_fingerprint>"\
key_file       = "<path_to_private_key>"\
region         = "<oci-region>"\
\pard\pardeftab720\partightenfactor0

\f3\fs24 \cf3 \strokec3 \
\pard\pardeftab720\sa298\partightenfactor0

\f0\fs36 \cf0 \strokec2 \uc0\u55357 \u56615 
\f1\b  Configure Terraform Variables\
\pard\pardeftab720\sa240\partightenfactor0

\f3\b0\fs24 \cf0 Define all required variables in 
\f6\b\fs26 terraform.tfvars
\f3\b0\fs24 :\
\pard\pardeftab720\partightenfactor0

\f4\fs26 \cf0 region                  = "us-ashburn-1"                         # Your OCI region\
compartment_id          = "ocid1.compartment.oc1..xxxxxx"        # Your OCI compartment OCID\
tenancy_ocid            = "ocid1.tenancy.oc1..xxxxxx"            # Your OCI tenancy OCID\
user_ocid               = "ocid1.user.oc1..xxxxxx"               # Your OCI user OCID\
fingerprint             = "your-api-key-fingerprint"             # Your OCI API key fingerprint\
private_key_path        = "/path/to/your/private_key.pem"        # Path to your private key\
\
oci_tunnel_ip           = "1.1.1.1"                              # Placeholder IP (to be updated)\
aws_access_key          = "xxxxxxxx"\
aws_secret_key          = "xxxxxxxxx"\
aws_token               = "xxxxx"\
\
vcn_cidr                = "10.0.0.0/23"\
vpc_cidr                = "10.1.0.0/16"\
\pard\pardeftab720\partightenfactor0

\f3\fs24 \cf3 \strokec3 \
\pard\pardeftab720\sa298\partightenfactor0

\f0\fs36 \cf0 \strokec2 \uc0\u55357 \u56960 
\f1\b  Deployment Steps\
\pard\pardeftab720\sa280\partightenfactor0

\f0\b0\fs28 \cf0 1\uc0\u65039 \u8419 
\f1\b  Initialize Terraform\
\pard\pardeftab720\sa240\partightenfactor0

\f3\b0\fs24 \cf0 Download necessary providers and prepare the working directory:\
\pard\pardeftab720\partightenfactor0

\f4\fs26 \cf0 terraform init\
\pard\pardeftab720\sa280\partightenfactor0

\f0\fs28 \cf0 2\uc0\u65039 \u8419 
\f1\b  Review the Plan\
\pard\pardeftab720\sa240\partightenfactor0

\f3\b0\fs24 \cf0 Preview the infrastructure changes:\
\pard\pardeftab720\partightenfactor0

\f4\fs26 \cf0 terraform plan\
\pard\pardeftab720\sa280\partightenfactor0

\f0\fs28 \cf0 3\uc0\u65039 \u8419 
\f1\b  Apply the Configuration\
\pard\pardeftab720\sa240\partightenfactor0

\f3\b0\fs24 \cf0 Apply the configuration to deploy OCI and AWS resources:\
\pard\pardeftab720\partightenfactor0

\f4\fs26 \cf0 terraform apply\
\pard\pardeftab720\sa240\partightenfactor0

\f3\fs24 \cf0 Type 
\f6\b\fs26 yes
\f3\b0\fs24  when prompted to confirm.\
\pard\pardeftab720\partightenfactor0
\cf3 \strokec3 \
\pard\pardeftab720\sa298\partightenfactor0

\f0\fs36 \cf0 \strokec2 \uc0\u9989 
\f1\b  Verify Deployment\
\pard\pardeftab720\sa240\partightenfactor0

\f3\b0\fs24 \cf0 Once deployment completes, verify resource creation:\
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa240\partightenfactor0
\ls5\ilvl0
\f1\b \cf0 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 OCI:
\f3\b0  VCN, DRG, DRG Attachment, CPE, and IPSEC Connection\
\ls5\ilvl0
\f1\b \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 AWS:
\f3\b0  VPC, VPN Gateway, Gateway Attachment, Customer Gateway, and VPN Connection\
\pard\pardeftab720\partightenfactor0
\cf3 \strokec3 \
\pard\pardeftab720\sa298\partightenfactor0

\f0\fs36 \cf0 \strokec2 \uc0\u9888 \u65039 
\f1\b  Important Final Step\
\pard\pardeftab720\sa240\partightenfactor0

\f3\b0\fs24 \cf0 This Terraform setup creates 
\f1\b AWS resources first
\f3\b0 , followed by 
\f1\b OCI resources
\f3\b0  to ensure dependencies (like the CPE in OCI) are properly configured.\uc0\u8232 Because AWS resources are created before OCI, a 
\f1\b placeholder IP
\f3\b0  is used for the OCI tunnel in AWS.\
To finalize the configuration:\
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa240\partightenfactor0
\ls6\ilvl0\cf0 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	1	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 In the OCI Console, navigate to the 
\f1\b IPSec Connection
\f3\b0  page.\
\ls6\ilvl0\kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	2	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Copy the 
\f1\b Tunnel 1 Public IP address
\f3\b0 .\
\ls6\ilvl0\kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	3	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Update the 
\f4\fs26 oci_tunnel_ip
\f3\fs24  in 
\f4\fs26 terraform.tfvars
\f3\fs24  with this value.\
\ls6\ilvl0\kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	4	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Reapply the configuration:\uc0\u8232 
\f4\fs26 terraform apply\
\pard\tx220\tx720\pardeftab720\li720\fi-720\partightenfactor0
\ls6\ilvl0\cf0 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	5	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 \uc0\u8232 
\f3\fs24 This will update the AWS CPE with the correct IP and establish the VPN tunnel.\
\pard\pardeftab720\partightenfactor0
\cf3 \strokec3 \
\pard\pardeftab720\sa298\partightenfactor0

\f0\fs36 \cf0 \strokec2 \uc0\u55358 \u56825 
\f1\b  Cleanup\
\pard\pardeftab720\sa240\partightenfactor0

\f3\b0\fs24 \cf0 To destroy all created resources:\
\pard\pardeftab720\partightenfactor0

\f4\fs26 \cf0 terraform destroy -auto-approve\
\pard\pardeftab720\partightenfactor0

\f3\fs24 \cf3 \strokec3 \
}
