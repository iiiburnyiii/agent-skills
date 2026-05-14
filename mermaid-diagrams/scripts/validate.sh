#!/usr/bin/env bash
# Validates a Mermaid diagram via mermaid.ink HTTP API.
# Usage: validate.sh <path-to-.mmd-file>
# Exit codes: 0 = valid, 1 = parse error, 2 = file/network error
set -euo pipefail

FILE="${1:?Usage: validate.sh <path-to-.mmd-file>}"

if [[ ! -f "$FILE" ]]; then
  echo "ERROR: File not found: $FILE" >&2
  exit 2
fi

# Encode diagram to base64url (RFC 4648 §5): replace + with -, / with _, strip padding =
# Standard base64 with / breaks the URL path — mermaid.ink returns 404 for those requests
B64=$(base64 -i "$FILE" | tr -d '\n' | tr '+/' '-_' | tr -d '=')
URL="https://mermaid.ink/svg/${B64}"

RESPONSE_FILE=$(mktemp)
trap 'rm -f "$RESPONSE_FILE"' EXIT

HTTP_CODE=$(curl -s -o "$RESPONSE_FILE" -w "%{http_code}" --max-time 15 "$URL" 2>/dev/null) || {
  echo "ERROR: Network request failed (no internet or mermaid.ink unreachable)" >&2
  exit 2
}

if [[ "$HTTP_CODE" == "200" ]]; then
  echo "OK: diagram is valid"
  exit 0
elif [[ "$HTTP_CODE" == "400" ]]; then
  echo "PARSE ERROR in $FILE:"
  cat "$RESPONSE_FILE"
  echo ""
  exit 1
else
  echo "ERROR: Unexpected HTTP $HTTP_CODE from mermaid.ink" >&2
  cat "$RESPONSE_FILE" >&2
  exit 2
fi
