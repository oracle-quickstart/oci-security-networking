# Azure Application Gateway for Oracle Autonomous AI Database@Azure

This Terraform configuration deploys an Azure Application Gateway into an existing VNet and subnet. It uses the Terraform AzAPI provider to create the Application Gateway with REST API version `2025-07-01`.

You can find the blog that talks about this at [https://www.ateam-oracle.com/oracle-dbazure-apex-vanity-url](https://www.ateam-oracle.com/oracle-dbazure-apex-vanity-url)

## What It Builds

- Standard public IP address.
- Application Gateway v2 using `Microsoft.Network/applicationGateways@2025-07-01`.
- HTTPS listener on port `443` using a local frontend PFX certificate.
- Backend pool pointing to the Oracle Autonomous AI Database@Azure FQDN.
- HTTPS backend settings with `sniName` set directly in the Application Gateway REST body.
- HTTPS health probe for `/ords/apex`.I patch, rewrite rule set, or backend trusted root certificate upload is used.

## Requirements

- The Azure Virtual Network (VNet) where the Application Gateway will be deployed must exist.
- The subnet where the Application Gateway will be deployed must exist.
- The Oracle Autonomous AI Database@Azure must already exist and be configured.
- A PFX certificate that will be used on Azure Application Gateway must already exist and it must be stored in the computer running the code.
- A public DNS server must exist and the DNS A record for the Azure Application Gateway must be manually configured.

## Usage

For better secret handling, keep the certificate password out of `terraform.tfvars` and export it instead:

```bash
export TF_VAR_ssl_certificate_password='your-pfx-password'
```

Then run:

```bash
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

After apply, create or update DNS so the desired host name resolves to the `public_ip_address` output.

## Important Inputs

| Variable | Purpose |
| --- | --- |
| `application_gateway_resource_group_name` | Existing resource group where the Application Gateway and public IP will be created. |
| `virtual_network_resource_group_name` | Existing resource group containing the VNet. |
| `virtual_network_name` | Existing VNet name. |
| `subnet_name` | Existing subnet dedicated to Application Gateway. |
| `ssl_certificate_pfx_path` | Local PFX file for the frontend listener certificate. |
| `ssl_certificate_password` | PFX password. Prefer `TF_VAR_ssl_certificate_password`. |
| `listener_host_names` | Frontend host names accepted by the HTTPS listener. |
| `backend_fqdn` | Oracle Autonomous AI Database@Azure backend host without scheme or path. Used as the backend pool FQDN, probe host, and backend SNI value. |

## TLS Notes

Client-to-gateway TLS is terminated with the local PFX certificate. Gateway-to-backend TLS uses HTTPS on port `443`, sets backend SNI to `backend_fqdn`, and relies on public certificate validation. No backend root certificates are uploaded.

The PFX data and password can be written to Terraform state because the certificate is loaded directly from disk. Use an encrypted remote backend with restricted access for real deployments.

## Existing Subnet Requirements

The subnet must be suitable for Application Gateway: dedicated to Application Gateway, in the same region as the gateway, and large enough for the selected capacity. Make sure any subnet NSG or route table allows Application Gateway management traffic and outbound HTTPS to the Oracle backend FQDN.

## Conclusion

Using Terraform makes this deployment available for Infrastructure as Code (IaC). Using provider `AzAPI` instead of `AzureRM` makes possible to configure the `sniName` inside the Application Gateway definition without using `terraform_data` resource.