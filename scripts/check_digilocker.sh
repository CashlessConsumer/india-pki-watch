#!/usr/bin/env bash
# DigiLocker Android app pin watch: re-fetch the xapk from APKPure,
# extract res/raw/*.cer pins, compare against the latest snapshot.
# Alert-worthy change: any pin hash differs (endpoint re-pin / chain swap).
set -euo pipefail
cd "$(dirname "$0")/.."
SNAP="$(ls -d govt-apps/digilocker-android/20* 2>/dev/null | sort | tail -1)"
[ -z "$SNAP" ] && { echo "no snapshot"; exit 2; }
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
XAPK="$TMP/dl.xapk"
curl -fsS -m 300 -o "$XAPK" "https://d.apkpure.com/b/XAPK/com.digilocker.android" 2>/dev/null \
  || { echo "FETCH FAIL (apkpure) — rerun via: bash Skills/apkeep-fetch/scripts/fetch-apk.sh com.digilocker.android"; exit 2; }
mkdir -p "$TMP/x"
unzip -o -q "$XAPK" -d "$TMP/x"
BASE_APK="$(ls "$TMP"/x/*.apk | head -1)"
unzip -o -q "$BASE_APK" -d "$TMP/b"
changed=0
while IFS= read -r f; do
  rel="${f#$TMP/b/res/raw/}"
  old="$SNAP/certs/$rel"
  new_h="$(sha256sum "$f" | awk '{print $1}')"
  if [ -f "$old" ]; then
    old_h="$(sha256sum "$old" | awk '{print $1}')"
    if [ "$old_h" != "$new_h" ]; then echo "PIN CHANGED: $rel ($old_h → $new_h)"; changed=1; fi
  else
    echo "PIN ADDED: $rel"; changed=1
  fi
done < <(find "$TMP/b/res/raw" -name "*.cer" 2>/dev/null | sort)
for old in "$SNAP"/certs/*.cer; do
  rel="$(basename "$old")"
  [ -f "$TMP/b/res/raw/$rel" ] || { echo "PIN REMOVED: $rel"; changed=1; }
done
[ "$changed" = 0 ] && echo "MATCH: all pins byte-identical to $SNAP"
exit 0
