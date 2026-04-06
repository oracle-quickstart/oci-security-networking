#!/bin/bash

set -euo pipefail

VIEW_ID="ocid1.dnsview.oc1.iad.amaaa****" #Update the Private View OCID
ZONE="abc.com" #Update the Zone name
CSV_FILE="records.csv" #Update the Csv filename 

# Expected CSV columns:
# DOMAIN,TYPE,TTL,RDATA
# RDATA can contain multiple values separated by "|"
#
# Example:
# host1.abc.com,A,3600,10.0.0.10|10.0.0.11
# host2.abc.com,AAAA,3600,2001:db8::10|2001:db8::11
# alias1.abc.com,CNAME,3600,target1.abc.com.

tail -n +2 "$CSV_FILE" | while IFS=, read -r DOMAIN TYPE TTL RDATA
do
  DOMAIN="$(echo "$DOMAIN" | xargs)"
  TYPE="$(echo "$TYPE" | xargs | tr '[:lower:]' '[:upper:]')"
  TTL="$(echo "$TTL" | xargs)"
  RDATA="$(echo "$RDATA" | xargs)"

  echo "Processing: DOMAIN=$DOMAIN TYPE=$TYPE TTL=$TTL RDATA=$RDATA"

  if [ -z "$DOMAIN" ] || [ -z "$TYPE" ] || [ -z "$TTL" ] || [ -z "$RDATA" ]; then
    echo "Skipping invalid row"
    continue
  fi

  case "$TYPE" in
    A|AAAA|CNAME)
      ;;
    *)
      echo "Skipping unsupported record type: $TYPE"
      continue
      ;;
  esac

  # Build JSON array for --items from multiple RDATA values separated by "|"
  ITEMS="["
  FIRST=true

  IFS='|' read -ra VALUES <<< "$RDATA"
  for VALUE in "${VALUES[@]}"; do
    VALUE="$(echo "$VALUE" | xargs)"
    [ -z "$VALUE" ] && continue

    if [ "$FIRST" = true ]; then
      FIRST=false
    else
      ITEMS+=","
    fi

    ITEMS+="{\"domain\":\"$DOMAIN\",\"rtype\":\"$TYPE\",\"ttl\":$TTL,\"rdata\":\"$VALUE\"}"
  done

  ITEMS+="]"

  if [ "$FIRST" = true ]; then
    echo "Skipping row with no valid RDATA values"
    continue
  fi

  echo "Updating RRSet: $DOMAIN [$TYPE]"
  oci dns record rrset update \
    --zone-name-or-id "$ZONE" \
    --domain "$DOMAIN" \
    --rtype "$TYPE" \
    --scope "PRIVATE" \
    --view-id "$VIEW_ID" \
    --items "$ITEMS" \
    --force
done

echo "Done!"