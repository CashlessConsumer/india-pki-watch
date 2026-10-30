# [OSINT] CCA India 2022 root certificates — evidence snapshot

**Purpose:** point-in-time preservation of the CCA India 2022 roots as published on
cca.gov.in, so any silent replacement is detectable. Fetch done directly from the Zo
sandbox (no geo-block encountered); no ocitwo needed.

- **Fetched (UTC):** 2026-10-30T06:32:55Z
- **Source page:** https://cca.gov.in/root_certificate.html (snapshot in this folder, sha256 e2587f66…)
- **Links as served:** `/cca/sites/default/files/files/CCAIndia2022.cer` and `/cca/sites/default/files/files/CCAIndia2022SPL.cer`
- **Both files' HTTP Last-Modified:** Wed, 17 Sep 2025 12:06:51 GMT

## Hashes (file as served)

| File | SHA256 |
| --- | --- |
| CCAIndia2022.cer (1896 bytes) | `2427c86a7f7e7bbe1684b75cfe96537ab080d00b7d6acf0c4453b438f246e0ee` |
| CCAIndia2022SPL.cer (1904 bytes) | `6e92017ece0e2e752a59b37c0ebf0fb958311cc585deda1fdf12790eb99b3caf` |

MD5 (secondary): `ec3980db10c61b623235703bdeb1a18c` / `bbb1e6c184c12eaf1ec242055499d855`.

## Decoded identity

| Field | CCA India 2022 | CCA India 2022 SPL |
| --- | --- | --- |
| Subject = Issuer (self-signed root) | C=IN, O=India PKI, CN=CCA India 2022 | C=IN, O=India PKI, CN=CCA India 2022 SPL |
| Serial | 762433EBDB26765A8560CD0AA82FE117 | 628281C6EEBEC73F78087E5FF58F49F4 |
| Validity | 2022-02-02 → 2042-02-02 | 2022-09-20 → 2042-09-20 |
| Key / sig | RSA 4096, sha256WithRSAEncryption | RSA 4096, sha256WithRSAEncryption |
| Basic constraints | critical, CA:TRUE | critical, CA:TRUE |
| Cert SHA256 fingerprint (DER) | 9A:3F:D3:17:67:98:E8:42:DD:CB:12:C2:62:F1:1C:FA:CC:A7:0A:8B:84:C6:EA:6F:DA:30:84:2A:95:A9:4C:D8 | B7:24:68:9B:79:B2:EF:94:21:EF:8F:5C:C7:33:EB:09:38:51:B1:70:EE:71:51:77:00:5A:09:F2:26:D8:C9:1A |

## Data-quality note

The SPL file as served fails strict PEM parsing in OpenSSL: it contains a stray
blank line between the base64 body and the `-----END CERTIFICATE-----` marker
(CRLF endings throughout). The embedded DER decodes cleanly once extracted
(`openssl asn1parse` OK). A CA publishing a root cert that fails its own strict
parse is a hygiene nit worth remembering, and it also means naive tooling
(`openssl x509 -in file.cer`) errors on it.

## Relation to eMudhra/emSign work

These are the India PKI roots relevant to the eMudhra/emSign chain investigation
(see `Projects/cyber/pages/emudhra/`, TrustCheck). If CCA re-issues or swaps these
files after 2026-10-30 without a public notice, diff against SHA256SUMS.txt here.
## Version control (2026-10-30)

This verification is its own git repo (local: `CyberOpsec/artifacts/cca-gov-in/`,
remote: `LogicIncZo/cca-root-watch` on GitHub — public, so the snapshot is
externally timestamped). Tamper-evidence chain: per-file sha256 in
`2026-10-30-root-certs/SHA256SUMS.txt` → initial commit hash → dated history
for every future re-fetch. To check for silent re-issue: run
`scripts/check.sh` (re-fetches both certs, `sha256sum -c` against the latest
snapshot). A mismatch = re-issue event; `git show <old-commit>:<path>` vs the
new file characterises what changed.
