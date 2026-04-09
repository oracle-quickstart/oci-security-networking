## Automate DNS Record Creation in OCI Private DNS Zones with Python or Bash

Managing DNS records in Oracle Cloud Infrastructure (OCI) is simple for small environments. However, as cloud environments scale across microservices, hybrid architectures, and large onboarding pipelines, manual DNS management becomes inefficient and error-prone.

Blog: 
https://www.ateam-oracle.com/automate-dns-record-creation-in-oci-private-dns-zone-with-python-or-bash

This project demonstrates how to automate DNS record management in OCI Private Zones using:

Bash + OCI CLI 
Python + OCI SDK 

## Problem Statement
In real-world environments:
  - DNS records are maintained in spreadsheets or CMDBs
  - Bulk onboarding requires multiple DNS entries
  - Manual updates via console are error-prone
  - Duplicate records and inconsistencies occur

## Requirements
  - Bulk processing
  - Input-driven automation (CSV / Excel)
  - Safe updates (avoid overwrites)
  - Repeatable execution

## Solution Architecture
  CSV / Excel → Script (Bash / Python) → OCI CLI / SDK → OCI Private DNS Zone
  Input Layer: CSV / Excel
  Processing Layer: Script validation & transformation
  Execution Layer: OCI CLI / SDK
  Output: DNS records created/updated

## Approach 1: Bash + OCI CLI

- How to Run (Bash Script)

  Login to OCI Cloud Shell and follow the below commands: 

  1. Create/Upload the CSV file
  
    Ex: records.csv
  
  2. Make script executable
  
  chmod +x dns_records_update.sh
  
  3. Execute the command by updating the PRIVATE_VIEW_OCID, ZONE_NAME and CSV_FILE.

  ./dns_records_update.sh -v <Private View OCID> -z <Zone Name> -f <CSV file name>


- Behavior
  1. Processes DNS records from a CSV input file
  2. Supports A, AAAA, and CNAME record types
  3. Handles multiple RDATA values using a delimiter (|)
  4. Dynamically constructs OCI CLI payloads
  5. Performs full RRSet updates (overwrite behavior)
  6. Executes one request per record set
- When to Use
  1. Bulk DNS record creation or updates
  2. CI/CD pipelines and automation scripts
  3. Scenarios where full overwrite is acceptable
  4. Quick, lightweight automation without complex logic

## Approach 2: Python + OCI SDK

- How to Run (Python Script)

  Login to OCI Cloud Shell and follow the below commands: 

  1. Install dependencies
  
    python3 -m pip install --user pandas
    pip install oci pandas openpyxl
  
  2. Run Script by updating the Zone_OCID, COMPARTMENT_OCID AND excel file parameters in the below command. 

    python3 script.py \
      -z <ocid1.dns-zone.xxx> \
      -c <ocid1.compartment.xxx> \
      -f <dns_sample.xlsx>

- Behavior
  1. Reads DNS records from an Excel input file
  2. Retrieves existing DNS records from OCI
  3. Compares desired state with current DNS state
  4. Performs incremental, add-only updates
  5. Prevents duplicate record creation
  6. Applies updates in batches for efficiency
  7. Does not overwrite or delete existing records
- When to Use
  1. Production environments requiring safe updates
  2. Incremental DNS synchronization workflows
  3. Managing services with multiple IP mappings
  4. Integration with Excel-based operational processes
  5. Scenarios requiring idempotent execution

Bash vs Python 

| Feature             | Bash (CLI) | Python (SDK) |
| ------------------- | ---------- | ------------ |
| Bulk Updates        | ✅         | ✅           |
| Incremental Updates | ❌         | ✅           |
| Overwrite Risk      | High       | Low          |
| Ease of Use         | Easy       | Moderate     |
| Production Ready    | ⚠️         | ✅           |



## Conclusion 

  Automating DNS record creation in OCI Private Zones significantly improves efficiency and reduces manual effort.
  
  By combining:
  
  Bash → simple and fast bulk updates
  Python → intelligent, safe, incremental updates

