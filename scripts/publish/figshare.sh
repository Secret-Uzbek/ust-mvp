#!/usr/bin/env bash
set -euo pipefail

FILE="${1:?zip file required}"
VERSION="${2:?version required}"
TOKEN="${FIGSHARE_TOKEN:?FIGSHARE_TOKEN secret required}"

API="https://api.figshare.com/v2"
AUTH=(-H "Authorization: token ${TOKEN}" -H "Content-Type: application/json")

echo "[figshare] create article"
ARTICLE_JSON=$(curl -sS -X POST "${API}/account/articles" "${AUTH[@]}" -d @- <<JSON
{
  "title": "UST MVP — Quantum Foundation (${VERSION})",
  "description": "UST MVP release bundle produced from GitHub tag ${VERSION}.",
  "keywords": ["UST","Quantum Foundation","Fractal Metascience","Terra"],
  "defined_type": "software"
}
JSON
)

ARTICLE_ID=$(python - <<'PY'
import json,sys
print(json.loads(sys.stdin.read())["location"].rstrip("/").split("/")[-1])
PY <<<"$ARTICLE_JSON")

echo "[figshare] initiate upload"
SIZE=$(python - <<PY
import os
print(os.path.getsize("$FILE"))
PY
)
UP=$(curl -sS -X POST "${API}/account/articles/${ARTICLE_ID}/files" "${AUTH[@]}" -d @- <<JSON
{ "name": "$(basename "$FILE")", "size": ${SIZE} }
JSON
)

FILE_ID=$(python - <<'PY'
import json,sys
j=json.loads(sys.stdin.read())
print(j["location"].rstrip("/").split("/")[-1])
PY <<<"$UP")

INFO=$(curl -sS -X GET "${API}/account/articles/${ARTICLE_ID}/files/${FILE_ID}" -H "Authorization: token ${TOKEN}")
UPLOAD_URL=$(python - <<'PY'
import json,sys
print(json.loads(sys.stdin.read())["upload_url"])
PY <<<"$INFO")

echo "[figshare] upload bytes"
curl -sS -X PUT "${UPLOAD_URL}" --data-binary @"${FILE}" >/dev/null

echo "[figshare] complete"
curl -sS -X POST "${API}/account/articles/${ARTICLE_ID}/files/${FILE_ID}/upload" -H "Authorization: token ${TOKEN}" >/dev/null

echo "[figshare] publish"
curl -sS -X POST "${API}/account/articles/${ARTICLE_ID}/publish" -H "Authorization: token ${TOKEN}" >/dev/null

echo "[figshare] done: ${ARTICLE_ID}"
