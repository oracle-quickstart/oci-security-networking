# AWS S3 to OCI Object Storage Data Transfer using rclone and Kubernetes

**Disclaimer:**

This code is provided as-is for demonstration purposes only. It may require modifications to suit your specific environment and security requirements. Use at your own risk.

## Overview

This repository contains sample code for transferring data from Amazon Web Services (AWS) S3 to Oracle Cloud Infrastructure (OCI) Object Storage using `rclone` and Kubernetes. This solution leverages Equinix Fabric for private network connectivity, offering enhanced security and predictable performance.

This configuration is based on the concepts discussed in the blog post "[OCI to AWS Large Transfer using Equinix](https://www.ateam-oracle.com/post/oci-to-aws-large-transfer-using-equinix)" which provides a detailed guide to performing petabyte-scale data transfers. This repository provides the code to be used with a Kubernetes to run in OCI and use workload identity and tokens for AWS. The purpose of this sample is to have a starting point to a more complex problem.

This setup utilizes a Kubernetes Job to orchestrate the data transfer using `rclone`. The Kubernetes Job leverages OCI Workload Identity for secure authentication to OCI Object Storage and token-based authentication for AWS S3.

## Components

*   `rclone-deployment.yaml`: Kubernetes Job definition that deploys the `rclone` container.
*   `rclone-config.yaml`: Kubernetes ConfigMap containing the `rclone.conf` file, which configures the AWS S3 and OCI Object Storage connections.
*   IAM Configuration: This section describes the OCI IAM and AWS IAM configuration required to execute this.

## Prerequisites

*   An active AWS account with an S3 bucket.
*   An active OCI account with an Object Storage bucket.
*   An Equinix Fabric account with private connectivity between AWS and OCI.
*   A Kubernetes cluster running within OCI IaaS.
*   `kubectl` installed and configured to connect to your Kubernetes cluster.
*   OCI CLI installed in the cloud shell that is going to create the dynamic group and polices.
*   An account with access to OCI APIs.
*   The cloud shell has been configured with your private key.

## Configuration

1.  **OCI IAM Configuration:**
    *   Create the Dynamic Group and Policies for OCI Workload Identity in the OCI Console, following the instructions in this blog.

2.  **AWS IAM Configuration:**
    *   Create a Kubernetes Secret containing your AWS Access Key ID and Secret Access Key:

    ```bash
    kubectl create secret generic aws-secret \
        --from-literal=aws_access_key_id=<YOUR_AWS_ACCESS_KEY_ID> \
        --from-literal=aws_secret_access_key=<YOUR_AWS_SECRET_ACCESS_KEY> \
        -n <your-namespace>
    ```

3.  **Update `rclone-config.yaml`:**
    *   Edit the `rclone-config.yaml` file and replace the following placeholders:
        *   `<your-namespace>`: Your Kubernetes namespace.
        *   `<YOUR_OCI_REGION>`: Your OCI region (e.g., `us-ashburn-1`).
        *   `<YOUR_OCI_NAMESPACE>`: Your OCI Object Storage namespace.
        *   `<YOUR_OCI_COMPARTMENT_OCID>`: Your OCI compartment OCID.
        *   `<YOUR_AWS_REGION>`: Your AWS region (e.g., `us-east-1`).

4.  **Update `rclone-deployment.yaml`:**
    *   Edit the `rclone-deployment.yaml` file and replace the following placeholders:
        *   `<your-bucket-name>`: The name of your AWS S3 bucket.
        *   `<your-job-name>`: A unique name for this rclone Job.
        *   `<your-namespace>`: The Kubernetes namespace where this Job will run.
        *   `<your-oci-workload-identity-sa>`: The name of your workload identity Kubernetes service account, this can be any-name.
        *   `<src-path>`: Where you expect the file to be replicated.
        *   `<dst-path>`: Path in the OCI to put it on.

## Deployment

1.  **Apply the ConfigMap:**

    ```bash
    kubectl apply -f rclone-config.yaml
    ```

2.  **Apply the Job:**

    ```bash
    kubectl apply -f rclone-deployment.yaml
    ```

3.  **Verify the Job:**

    ```bash
    kubectl get jobs -n <your-namespace>
    kubectl logs -l app=rclone-bucket -n <your-namespace> -f
    ```

## Scaling

To adjust the transfer performance, modify the `spec.parallelism` field in the `rclone-deployment.yaml` file to increase or decrease the number of concurrent `rclone` pods. Also, take in consideration to modify `RCLONE_TRANSFERS` or `RCLONE_CHECKERS` to the job, so it takes that in consideration.

## Troubleshooting

*   Authentication Errors: Verify that the OCI Dynamic Group and IAM Policies are configured correctly, and that the AWS Secret is properly created.
*   Connectivity Issues: Ensure that your Kubernetes cluster has network connectivity to both AWS S3 and OCI Object Storage endpoints.
*   Performance Bottlenecks: Monitor CPU, memory, and network utilization to identify any bottlenecks. Adjust `rclone` parameters (e.g., `--transfers`, `--buffer-size`) accordingly.
*   `OCI Region needs to match the OCI namespace`.