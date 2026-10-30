# cca-root-watch

Tamper-evident snapshots of the Controller of Certifying Authorities (CCA,
India) root CA certificates from https://cca.gov.in/root_certificate.html.

Context: the Oct 2026 eMudhra/emSign chain compromise made India's CA trust
anchors first-class evidence. The `CCA India 2022` roots below are in current
trust stores. This repo records exactly what cca.gov.in served on each
snapshot date, so any silent re-issue (key rotation, re-issuance, quiet
remediation) is detectable by diff — nothing gets memory-holed.

## Snapshot 2026-10-30

Fetched 2026-10-30 06:32 UTC from
`https://cca.gov.in/cca/sites/default/files/files/<file>`; both files
`Last-Modified: Wed, 17 Sep 2025 12:06:51 GMT`. See
`2026-10-30-root-certs/` (raw certs, HTTP headers, page HTML, SHA256SUMS)
and `notes/2026-10-30-cca-india-2022-root-snapshot.md`.

| File | SHA256 (file as served) | Decoded identity |
| --- | --- | --- |
| `CCAIndia2022.cer` (1896 B) | `2427c86a7f7e7bbe1684b75cfe96537ab080d00b7d6acf0c4453b438f246e0ee` | Root CA, `CN=CCA India 2022`, serial `762433EBDB26765A8560CD0AA82FE117`, valid 2022-02-02→2042-02-02, RSA-4096/sha256, self-signed |
| `CCAIndia2022SPL.cer` (1904 B) | `6e92017ece0e2e752a59b37c0ebf0fb958311cc585deda1fdf12790eb99b3caf` | Root CA, `CN=CCA India 2022 SPL`, serial `628281C6EEBEC73F78087E5FF58F49F4`, valid 2022-09-20→2042-09-20, RSA-4096/sha256, self-signed |

Corresponding x509 (DER) fingerprints:
`9A:3F:D3:17:67:98:E8:42:DD:CB:12:C2:62:F1:1C:FA:CC:A7:0A:8B:84:C6:EA:6F:DA:30:84:2A:95:A9:4C:D8`
(2022) and
`B7:24:68:9B:79:B2:EF:94:21:EF:8F:5C:C7:33:EB:09:38:51:B1:70:EE:71:51:77:00:5A:09:F2:26:D8:C9:1A`
(2022 SPL).

Known quirk (observed 2026-10-30): `CCAIndia2022SPL.cer` as served contains a
stray blank line between the base64 body and the `END CERTIFICATE` marker, so
`openssl x509 -in CCAIndia2022SPL.cer` refuses to parse it. The embedded DER
is intact — extract with
`awk '/BEGIN/{f=1;next}/END/{f=0}f' CCAIndia2022SPL.cer | tr -d '\r\n' | base64 -d | openssl x509 -inform DER -noout -text`.

## Checking for silent re-issue

```bash
scripts/check.sh            # re-fetch both certs, sha256sum -c vs latest snapshot
```

On mismatch: the certs changed. `git log` the snapshot dirs for the
last-known-good state, decode the new files (subject / serial / key /
validity), commit a new dated snapshot dir, and characterise the change
(same key re-issued? new key? new validity?). A `Last-Modified` newer than
`2025-09-17 12:06:51 GMT` with unchanged bytes is also worth noting.

## Layout

- `20YY-MM-DD-root-certs/` — one dated snapshot per fetch: `.cer` files as
  served, raw response headers, page HTML, `SHA256SUMS.txt`
- `notes/` — per-snapshot write-ups
- `scripts/check.sh` — re-fetch + verify against latest snapshot

Certs and page content are public records of cca.gov.in; snapshots are for
verification and research.
