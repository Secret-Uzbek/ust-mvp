#!/usr/bin/env bash
set -euo pipefail

FILE="${1:?zip file required}"
VERSION="${2:?version required}"

API_BASE="https://zenodo.org/api"
TOKEN="${ZENODO_TOKEN:?ZENODO_TOKEN secret required}"

echo "[zenodo] create deposition"
DEP_JSON=$(curl -sS -X POST -H "Content-Type: application/json" \
  "${API_BASE}/deposit/depositions?access_token=${TOKEN}" -d "{}")

DEP_ID=$(python - <<'PY'
import json,sys
print(json.loads(sys.stdin.read())["id"])
PY <<<"$DEP_JSON")

BUCKET=$(python - <<'PY'
import json,sys
print(json.loads(sys.stdin.read())["links"]["bucket"])
PY <<<"$DEP_JSON")

echo "[zenodo] upload file"
curl -sS -X PUT -H "Content-Type: application/octet-stream" \
  --data-binary @"${FILE}" \
  "${BUCKET}/$(basename "${FILE}")?access_token=${TOKEN}" >/dev/null

echo "[zenodo] set metadata"
curl -sS -X PUT -H "Content-Type: application/json" \
  "${API_BASE}/deposit/depositions/${DEP_ID}?access_token=${TOKEN}" \
  -d @- >/dev/null <<JSON
{
  "metadata": {
    "title": "UST MVP — Quantum Foundation (${VERSION})",
    "upload_type": "software",
    "description": "UST MVP release bundle produced from GitHub tag ${VERSION}. Includes source + site artifact + checksums.",
    "creators": [{"name": "Abdukarimov, Abdurashid", "orcid": "0009-0000-6394-4912"}],
    "version": "${VERSION}",
    "license": "cc-by-4.0"
  }
}
JSON

echo "[zenodo] publish"
PUB=$(curl -sS -X POST "${API_BASE}/deposit/depositions/${DEP_ID}/actions/publish?access_token=${TOKEN}")
python - <<'PY'
import json,sys
j=json.loads(sys.stdin.read())
print("[zenodo] published:", j.get("links",{}).get("html"))
PY <<<"$PUB"
