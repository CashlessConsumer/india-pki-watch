#!/usr/bin/env bash
# Re-fetch the CCA India 2022 roots and verify them against the latest snapshot.
set -euo pipefail
cd "$(dirname "$0")/.."
SNAP="$(ls -d cca-gov-in/20*-root-certs 2>/dev/null | sort | tail -1)"
[ -n "$SNAP" ] || { echo "ERROR: no snapshot dir found" >&2; exit 1; }
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
BASE="https://cca.gov.in/cca/sites/default/files/files"
for f in CCAIndia2022.cer CCAIndia2022SPL.cer; do
  curl -fsS -o "$TMP/$f" "$BASE/$f"
  curl -fsS -D "$TMP/headers_$f.txt" -o /dev/null "$BASE/$f"
done
echo "server Last-Modified now:"
grep -i "^last-modified" "$TMP"/headers_*.txt || true
echo "snapshot: $SNAP"
grep -E 'CCAIndia2022(SPL)?\.cer$' "$SNAP/SHA256SUMS.txt" > "$TMP/expected.txt"
if (cd "$TMP" && sha256sum -c expected.txt); then
  echo "MATCH: certs unchanged since $SNAP"
  echo "note: byte equality does not prove no re-issue if Last-Modified moved;"
  echo "compare headers and re-decode: openssl x509 -inform DER after base64 extract"
else
  echo "MISMATCH: certs changed since $SNAP — re-issue event."
  echo "Characterise: decode new certs, git diff against $SNAP, commit a new dated snapshot."
  exit 1
fi
