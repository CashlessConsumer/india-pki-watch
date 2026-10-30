# [REVIEW] emSign/eMudhra public repository — full corpus snapshot

2026-10-30. Repo: `CashlessConsumer/india-pki-watch`, dir
`emsign-repository/2026-10-30-full-corpus/`.

## What

repository.emsign.com publishes 116 CA certificates (roots, cross-signs, EM
DV/OV/EV TLS + CS + SMIME + TSA intermediates, UAE/Kenya/Mauritius QTSP CAs)
with declared SHA-256 fingerprints inline in the page JS (`var CERTS`).

Fetched all 116 + per-file response headers + the AIA-served
`EMDVTLSCAG2A1EE.p7c` chain. Manifest: SHA256SUMS.txt (236 entries).

## Verification

- 116/116 file sha256 == publisher-declared fingerprint. Zero mismatches.
- Incident-relevant roots captured: `emSignECCRootCAG3.crt`
  (fp 86:a1:ec:ba:08:9c:4a:8d:3b:be:27:34:c6:12:ba:34:1d:81:3e:04:3c:f9:e8:a8:62:cd:5c:57:a3:6b:be:6b),
  `roottlscag3.crt` (`emSign Root TLS CA - G3`), G1/G2/C-series roots, all
  cross-signs.
- Served-in-the-wild tie-in: `EMDVTLSCAG2A1.crt` (repository copy) is
  byte-identical to the intermediate serving *.bank.in hosts captured in
  `CyberOpsec/data/runs/bankin-tls-2026-10-22/` (25 eMudhra + 8 emSign issuers
  across the live 2026-10-22 sweep).
- TrustCheck test fixture `emsign-ecc-g3.pem` == corpus G3 (same fingerprint,
  PEM re-encode only) — fixture provenance now grounded.

## Why it matters

1. The eMudhra/emSign incident (cyber.cashlessconsumer.in/pages/emudhra/)
   turns on what roots exist and when. This corpus is the "before" record; any
   silent re-issue under the same name now has a git-dated baseline.
2. .bank.in — the entire namespace's TLS currently chains into eMudhra EM DV
   TLS CA - G2A-1 → emSign Root TLS CA - G1. The archive now holds every link
   as published, with the CA's own fingerprints to check against.

## Caveats

- repository.emsign.com drops connections intermittently; check script
  retries 3x. A fetch-fail is not a mismatch.
- Fingerprint match ≠ not-compromised: it only proves the CA still publishes
  the same key. Key-material compromise is out of scope; this pins the
  published record over time.
