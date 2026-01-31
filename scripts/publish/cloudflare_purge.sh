#!/usr/bin/env bash
set -euo pipefail

: "${CF_TOKEN:?CF_TOKEN required}"
: "${CF_ZONE:?CF_ZONE required}"

if [[ -z "${CF_URLS_JSON:-}" ]]; then
  echo "[cloudflare] CF_URLS_JSON empty; skip."
  exit 0
fi

curl -sS -X POST "https://api.cloudflare.com/client/v4/zones/${CF_ZONE}/purge_cache" \
  -H "Authorization: Bearer ${CF_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{"files": ${CF_URLS_JSON}}" | python - <<'PY'
import json,sys
print(json.loads(sys.stdin.read()).get("success"))
PY
