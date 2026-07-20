import oci
import pandas as pd
import argparse

# ================================
# ARGUMENT PARSING
# ================================
parser = argparse.ArgumentParser(description="OCI DNS Record Automation Script")

parser.add_argument("-z", "--zone", required=True, help="Zone OCID")
parser.add_argument("-c", "--compartment", required=True, help="Compartment OCID")
parser.add_argument("-f", "--file", required=True, help="Excel file path")

args = parser.parse_args()

ZONE_NAME = args.zone
COMPARTMENT_ID = args.compartment
EXCEL_FILE = args.file
SUPPORTED_TYPES = {"A", "AAAA", "CNAME"}

# ================================
# OCI CLIENT
# ================================
config = oci.config.from_file()
dns_client = oci.dns.DnsClient(config)

def normalize_domain(domain: str) -> str:
    # ensure no trailing dot for consistent compare
    return str(domain).strip().rstrip(".")

def normalize_rdata(rtype: str, rdata: str) -> str:
    rtype = rtype.upper().strip()
    rdata = str(rdata).strip()
    if rtype == "CNAME":
        # Normalize target with trailing dot (OCI commonly stores it this way)
        return rdata.rstrip(".") + "."
    return rdata

# ================================
# STEP 1: READ EXCEL (4 columns)
# Expected columns: rtype | domain | ttl | rdata
# ================================
df = pd.read_excel(EXCEL_FILE, header=None)
df.columns = ["rtype", "domain", "ttl", "rdata"]

# ================================
# STEP 2: FETCH EXISTING RECORDS (A/AAAA/CNAME)
# ================================
existing_records = {}
response = oci.pagination.list_call_get_all_results(
    dns_client.get_zone_records,
    zone_name_or_id=ZONE_NAME,
    compartment_id=COMPARTMENT_ID
)

for record in response.data.items:
    rtype = record.rtype.upper().strip()
    if rtype not in SUPPORTED_TYPES:
        continue
    domain = normalize_domain(record.domain)
    rdata = normalize_rdata(rtype, record.rdata)
    existing_records.setdefault((domain, rtype), set()).add(rdata)

# ================================
# STEP 3: BUILD PATCH OPERATIONS - ADD ONLY
# ================================
patch_items = []
for _, row in df.iterrows():
    rtype = str(row["rtype"]).strip().upper()
    if rtype not in SUPPORTED_TYPES:
        continue
    domain = normalize_domain(row["domain"])
    ttl = int(row["ttl"])
    rdata = normalize_rdata(rtype, row["rdata"])
    key = (domain, rtype)

    # ADD-ONLY: if exact record exists, skip; otherwise add
    if key in existing_records and rdata in existing_records[key]:
        print(f"No change (already exists): {rtype} {domain}")
        continue

    print(f"Creating: {rtype} {domain} -> {rdata}")
    patch_items.append(
        oci.dns.models.RecordOperation(
            operation="ADD",
            domain=domain,
            rtype=rtype,
            ttl=ttl,
            rdata=rdata
        )
    )

# ================================
# STEP 4: APPLY CHANGES (BATCH)
# ================================
if not patch_items:
    print("No changes to apply.")
else:
    batch_size = 25
    for i in range(0, len(patch_items), batch_size):
        batch = patch_items[i:i + batch_size]
        dns_client.patch_zone_records(
            zone_name_or_id=ZONE_NAME,
            patch_zone_records_details=oci.dns.models.PatchZoneRecordsDetails(items=batch),
            compartment_id=COMPARTMENT_ID
        )
        print(f"Batch {i // batch_size + 1} applied")
    print("DNS sync completed successfully")