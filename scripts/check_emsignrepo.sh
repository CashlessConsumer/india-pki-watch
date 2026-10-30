#!/usr/bin/env bash
# emSign/eMudhra public repository watch: re-fetch every published cert,
# verify against the CA's published fingerprints, then diff bytes vs latest snapshot.
set -euo pipefail
cd "$(dirname "$0")/.."
SNAP="$(ls -d emsign-repository/20*-full-corpus 2>/dev/null | sort | tail -1)"
[ -n "$SNAP" ] || { echo "ERROR: no emsign-repository snapshot dir" >&2; exit 1; }
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
mkdir "$TMP/certs"
curl -fsS -o "$TMP/repository-index.html" "https://repository.emsign.com/"
python3 - "$TMP/repository-index.html" "$TMP" <<'EOF'
import re, sys, json
h = open(sys.argv[1], encoding="utf-8", errors="replace").read()
m = re.search(r"var CERTS = \[(.*?)\];\s*\n", h, re.S)
roots = re.findall(r"n: '([^']+)', c: '([^']+)', r: '[^']+', f: '([^']+)'", m.group(1))
json.dump([{"name": n, "file": c, "sha256_fingerprint": f.lower()} for n, c, f in roots], open(f"{sys.argv[2]}/inventory.json", "w"), indent=1)
open(f"{sys.argv[2]}/certs.list", "w").write("\n".join(c for _, c, _ in roots) + "\n")
EOF
fail=0
while read -r c; do
  out="$TMP/certs/$(echo "$c" | tr '/' '_')"
  ok=0; for try in 1 2 3; do curl -fsS -m 25 -o "$out" "https://repository.emsign.com/certs/$c" && { ok=1; break; }; sleep 3; done; [ "$ok" = 1 ] || { echo "FETCH FAIL: $c"; fail=1; continue; }
  exp="$(python3 -c "import json,sys; i=json.load(open('$TMP/inventory.json')); print(next(e['sha256_fingerprint'] for e in i if e['file']=='$c'))" | tr -d ':' | tr 'A-F' 'a-f')"
  got="$(sha256sum "$out" | cut -d' ' -f1)"
  [ "$got" = "$exp" ] || { echo "FINGERPRINT MISMATCH: $c live=$got published=$exp"; fail=1; }
done < "$TMP/certs.list"
[ "$fail" = 0 ] && echo "all live certs match published fingerprints"
echo "snapshot: $SNAP"
changed=0
while read -r c; do
  name="$(echo "$c" | tr '/' '_')"
  [ -f "$TMP/certs/$name" ] || continue
  exp="$(grep -E "certs/$name\$" "$SNAP/SHA256SUMS.txt" | cut -d' ' -f1 || true)"
  got="$(sha256sum "$TMP/certs/$name" | cut -d' ' -f1)"
  if [ -n "$exp" ] && [ "$exp" != "$got" ]; then echo "BYTE CHANGE vs snapshot: $c"; changed=1; fi
done < "$TMP/certs.list"
[ "$changed" = 0 ] && echo "MATCH: all certs byte-identical to $SNAP"
exit 0
