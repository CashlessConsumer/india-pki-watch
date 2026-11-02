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
FETCH_DIR="$TMP/apk"
mkdir -p "$FETCH_DIR"
bash /home/workspace/Skills/apkeep-fetch/scripts/fetch-apk.sh -o "$FETCH_DIR" com.digilocker.android
BUNDLE="$(find "$FETCH_DIR" -type f \( -name '*.xapk' -o -name '*.apkm' -o -name '*.apk' \) | sort | head -1)"
[ -n "$BUNDLE" ] || { echo "FETCH FAIL (apkeep-fetch returned no APK bundle)"; exit 2; }
mkdir -p "$TMP/x" "$TMP/b"
case "$BUNDLE" in
  *.apk) BASE_APK="$BUNDLE" ;;
  *)
    unzip -o -q "$BUNDLE" -d "$TMP/x"
    BASE_APK="$(find "$TMP/x" -maxdepth 1 -type f -name 'com.digilocker.android.apk' -print -quit)"
    [ -n "$BASE_APK" ] || BASE_APK="$(find "$TMP/x" -maxdepth 1 -type f -name '*.apk' | sort | head -1)"
    [ -n "$BASE_APK" ] || { echo "FETCH FAIL (bundle contains no base APK)"; exit 2; }
    ;;
esac
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
