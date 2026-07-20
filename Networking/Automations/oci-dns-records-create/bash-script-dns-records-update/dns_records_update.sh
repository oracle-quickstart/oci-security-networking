#!/bin/bash

set -euo pipefail

usage() {
  cat <<EOF
Usage:
  $0 --view-id <VIEW_ID> --zone <ZONE> --file <CSV_FILE>
  $0 -v <VIEW_ID> -z <ZONE> -f <CSV_FILE>

Example:
  $0 --view-id ocid1.dnsview.oc1.iad.xxxxx --zone abc.com --file records.csv
  $0 -v ocid1.dnsview.oc1.iad.xxxxx -z abc.com -f records.csv
EOF
  exit 1
}

VIEW_ID=""
ZONE=""
CSV_FILE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --view-id|-v)
      VIEW_ID="${2:-}"
      shift 2
      ;;
    --zone|-z)
      ZONE="${2:-}"
      shift 2
      ;;
    --file|-f)
      CSV_FILE="${2:-}"
      shift 2
      ;;
    --help|-h)
      usage
      ;;
    *)
      echo "Unknown parameter: $1"
      usage
      ;;
  esac
done

if [[ -z "$VIEW_ID" || -z "$ZONE" || -z "$CSV_FILE" ]]; then
  echo "Error: Missing required arguments"
  usage
fi

if [[ ! -f "$CSV_FILE" ]]; then
  echo "Error: CSV file not found: $CSV_FILE"
  exit 1
fi

trim() {
  local s="$1"
  s="${s//$'\r'/}"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  s="${s#\"}"
  s="${s%\"}"
  printf '%s' "$s"
}

tail -n +2 "$CSV_FILE" | tr -d '\r' | while IFS=, read -r DOMAIN TYPE TTL RDATA
do
  DOMAIN="$(trim "$DOMAIN")"
  TYPE="$(trim "$TYPE" | tr '[:lower:]' '[:upper:]')"
  TTL="$(trim "$TTL")"
  RDATA="$(trim "$RDATA")"

  echo "Processing: DOMAIN=$DOMAIN TYPE=$TYPE TTL=$TTL RDATA=$RDATA"

  if [[ -z "$DOMAIN" || -z "$TYPE" || -z "$TTL" || -z "$RDATA" ]]; then
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

  ITEMS="["
  FIRST=true

  IFS='|' read -ra VALUES <<< "$RDATA"
  for VALUE in "${VALUES[@]}"; do
    VALUE="$(trim "$VALUE")"
    [[ -z "$VALUE" ]] && continue

    if [[ "$FIRST" == true ]]; then
      FIRST=false
    else
      ITEMS+=","
    fi

    ITEMS+="{\"domain\":\"$DOMAIN\",\"rtype\":\"$TYPE\",\"ttl\":$TTL,\"rdata\":\"$VALUE\"}"
  done

  ITEMS+="]"

  if [[ "$FIRST" == true ]]; then
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