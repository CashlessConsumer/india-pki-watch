# india-pki-watch

Tamper-evident archive of India PKI trust anchors and the CAs that serve them.
Every fetch is snapshotted with HTTP headers + SHA256SUMS, never edited after
the fact. A re-issue that changes bytes under the same name shows up as a diff
against git history. Desk: CyberOpsec. Repo: CashlessConsumer/india-pki-watch.

## Sources

| Dir | What | Status |
| --- | --- | --- |
| `cca-gov-in/` | CCA India 2022 root + SPL as published on cca.gov.in/root_certificate.html | watching (weekly) |
| `emsign-repository/` | Full 116-cert corpus from repository.emsign.com (emSign/eMudhra; roots incl. incident-relevant `emSign ECC Root CA - G3`, `emSign Root TLS CA - G3`, cross-signs, EM DV/OV/EV TLS intermediates incl. the one serving .bank.in) | watching (weekly) |
| `idrbt-ca/` | IDRBT CA — no fetchable root found; infra findings recorded | findings only, 2026-10-30 |
| `nic-ca/` | NIC CA — no public repository endpoint located | candidate, not seeded |

## Layout

```
<source>/<YYYY-MM-DD>-<snapshot>/
  *.crt|*.cer        files as served (bytes preserved)
  headers_*.txt      per-file response headers (Last-Modified/ETag)
  inventory.json     publisher-declared fingerprints (emSign)
  SHA256SUMS.txt     manifest covering the whole snapshot
```

Rule: snapshots are immutable. A change = new dated dir + one commit. Git
history is the tamper log.

## Scripts

- `scripts/check_ccaindia.sh` — re-fetch CCA roots, compare bytes + Last-Modified vs latest snapshot.
- `scripts/check_emsignrepo.sh` — re-fetch all published certs, verify each against emSign's own published SHA-256 fingerprint, then diff bytes vs snapshot (3 retries; the repository server drops connections).
- Both exit 0 on no-change, print diffs/failures otherwise. Run by the weekly watcher agent (Discord #security on anomaly).

## Cross-checks done at seed time (2026-10-30)

- CCA certs: DER bodies decode to `CN=CCA India 2022` (self-signed, 4096-bit RSA, 2022-02-02 → 2042-02-02) and `CN=CCA India 2022 SPL` (2022-09-20 → 2042-09-20). SPL PEM has a stray blank line inside the base64 — openssl strict parse fails; DER body valid.
- emSign corpus: 116/116 file sha256 == publisher-declared fingerprint. Repository copy of `EM DV TLS CA - G2A-1` == the cert actually served to .bank.in hosts (captured in CyberOpsec data/runs/bankin-tls-2026-10-22, 25 eMudhra + 8 emSign issuers in the live sweep).
- TrustCheck fixture `emsign-ecc-g3.pem` == this corpus's `emSignECCRootCAG3.crt` (same key/fingerprint 86:a1:ec:ba…; different PEM encoding).

## Known-findings log

- idrbtca.org.in apex: TCP timeout from both sandbox and ocitwo (Indian vantage) — not geo-fencing, host down/deaf. `praman.idrbtca.org.in` → 404, `idrbtca.org.in/crl_27B0.crl` → 403 (2026-10-30).
- nicca.nic.in: TCP timeout from India; nic.in/nicca page has no cert links.
- emsign.com marketing site redirects to Sectigo CertiNext branding; the live repository is repository.emsign.com (AIA `repository.emsign.com/certs/*.p7c`).
## Docsign: certificates that sign government documents

Track **document-signing trust anchors** for papers citizens rely on: eAadhaar PDFs (UIDAI, chains to CCA India), CoWIN certificates (MoHFW), DigiLocker-issued documents, ITR/Form-16 (ITD), EPFO, MCA company certificates, DigiLocker issuer signatures (API Setu / NeGD).

What lives here (`docsign/`, `govt-apps/`):

- `govt-apps/digilocker-android/2026-10-30/` — **13 endpoint-pin certs shipped inside the DigiLocker Android app** (com.digilocker.android, APKPure, fetched 2026-10-30). 20 unique certs: apisetu.gov.in, digilocker.gov.in, digitallocker.gov.in, dl6.in, ndma.gov.in pins **with full chains embedded in the PKCS#7 blobs** — including self-signed `emSign Root CA - G1` and `emSign Root TLS CA - G1`. Three certs are **byte-identical to the emSign repository corpus** (sha256-matched): EM DV TLS CA - G2A-1, emSign Root CA - G1, cross-signed emSign Root TLS CA - G1. This is hard evidence that India's flagship documents app pins eMudhra/emSign chains for its API traffic.
- Check: `bash scripts/check_digilocker.sh` — re-fetches the xapk and diffs every pin hash against the snapshot (PIN ADDED/CHANGED/REMOVED).

Why endpoint pins matter here: a pin swap is how a silent trust change would ship to every DigiLocker user. Diffing pins per app version catches it.

### Docsign gaps (next to seed)

- **UIDAI eAadhaar document-signing cert** — must be extracted from a real eAadhaar PDF (UIDAI publishes no standalone copy; offline-eKYC key pages 404 even from Indian vantage). Route: user drops an eAadhaar in Downloads; extract the signer cert locally; the PDF (PII) never enters the repo.
- **CoWIN QR public key** — not in the verify page JS bundle; `cdn-api.co-vin.in/api/v2/auth/publicKey` 401s. Chase the Android verifier app.
- **mAadhaar APK** — apkeep fetches returned empty (wrong package name or delisting); retry with correct package.
- Server-certificate pins for other govt apps (UMANG, mParivahan, Ayushman) — same extraction pipeline as DigiLocker.
- NIC CA (nicca.nic.in) root + subscriber CAs; IDRBT CA hierarchy (apex deaf, worth an RTI on who operates it now).
