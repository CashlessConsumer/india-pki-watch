# [OSINT] emSign/eMudhra repository — 2026-11-02 corpus delta

## Capture and comparison

- Source: https://repository.emsign.com/ and `https://repository.emsign.com/certs/`.
- Index response: HTTP 200, `Date: Mon, 02 Nov 2026 02:09:13 GMT`.
- Publisher inventory: 131 certificates, up from 116 in `2026-10-30-full-corpus`.
- Delta: 15 newly listed certificates; 0 removed; all 116 previously archived certificates remain byte-identical. All 131 downloaded files match the SHA-256 fingerprints declared by emSign in its index.
- All 15 new files report `Last-Modified: Wed, 28 Oct 2026 10:22:30 GMT`.
- Full snapshot: `emsign-repository/2026-11-02-full-corpus/`. Its `SHA256SUMS.txt` covers 265 files (131 certificates, 131 response-header files, the index response headers, publisher inventory, and raw index); all 265 entries verify.

## Newly listed certificates

The eight UAE QTSP certificates share subject prefix `C=AE, organizationIdentifier=NTRAE-DMCC.JLT-67851, O=eMudhra FZCO`; each is issued by `C=US, OU=emSign PKI, O=eMudhra Inc, CN=emSign Root CA - C1` (issuer fingerprint `12:56:09:AA:30:1D:A0:A2:49:B9:7A:82:39:CB:6A:34:21:6F:44:DC:AC:9F:39:54:B1:42:92:F2:E8:C8:60:8F`). They are valid from August 6, 2026 to August 5, 2036.

| File | Subject CN | SHA-256 certificate fingerprint |
|---|---|---|
| `UAE-QTSP-Advanced-CA.crt` | UAE QTSP Advanced CA | `02:9F:54:FD:DC:7E:C4:92:74:70:37:A5:24:E9:D6:A1:3C:80:23:6D:53:48:7E:75:C4:ED:CC:19:1E:FE:70:BB` |
| `UAE-QTSP-Device-and-Management-CA.crt` | UAE QTSP Device and Management CA | `D9:65:6F:4E:4D:83:F6:27:83:D9:AD:E6:01:04:EE:D9:0D:9C:C5:0C:29:A6:EF:0A:78:36:77:51:D2:F8:C7:48` |
| `UAE-QTSP-Qualified-eSeal-CA-LP.crt` | UAE QTSP Qualified eSeal CA LP | `E3:47:3A:EC:EF:10:8B:1E:E6:F4:9E:17:7B:25:02:36:05:A0:C0:41:B1:D9:7A:9F:59:CF:FC:00:D2:2E:02:51` |
| `UAE-QTSP-Qualified-eSeal-CA-LP-QSCD.crt` | UAE QTSP Qualified eSeal CA LP-QSCD | `6B:1E:A2:DE:E0:F3:4A:7E:53:D6:4E:BB:F3:9C:58:3D:AF:94:18:D8:3A:5A:A9:E6:25:8E:4F:2B:E7:07:B3:6E` |
| `UAE-QTSP-Qualified-eSignature-CA-NP.crt` | UAE QTSP Qualified eSignature CA (NP) | `8C:57:10:BF:16:01:91:97:95:67:3E:9F:F9:7F:9C:19:AC:C7:FA:47:8E:9E:99:CB:6C:F5:B6:12:A9:6C:69:7B` |
| `UAE-QTSP-Qualified-eSignature-CA-NP-QSCD.crt` | UAE QTSP Qualified eSignature CA NP-QSCD | `DB:9F:48:A5:31:06:A0:6A:00:47:2F:F1:82:91:45:02:FE:5C:81:6B:BC:4B:B5:46:83:32:39:69:19:BE:E5:71` |
| `UAE-QTSP-TSA-Issuing-CA.crt` | UAE QTSP TSA Issuing CA | `40:74:18:90:4F:71:B2:A0:B2:E3:5F:45:AD:88:C3:11:25:B1:C5:21:31:D4:F7:2F:A8:21:F8:3A:47:1D:C8:40` |
| `UAE-QTSP-Validation-Service-CA.crt` | UAE QTSP Validation Service CA | `32:13:CE:37:22:4C:4E:95:4D:AA:AE:ED:DA:09:8E:B7:08:91:1D:05:48:FD:3E:30:ED:8F:FC:18:41:BD:5D:65` |

The seven InCommon certificates have subject prefix `C=US, O=Internet2`. All are valid from April 8, 2026 to April 7, 2029. The G2C group chains to `emSign Root TLS CA - G1` (issuer fingerprint `CE:F7:1E:70:B7:C2:9A:DD:F6:C3:0C:D1:9E:61:4B:38:FD:5F:02:A4:35:A0:EE:DD:D0:08:7E:18:3D:10:1A:51`); the G3C group chains to `emSign Root TLS CA - G3` (issuer fingerprint `7D:D7:8D:5F:4F:13:45:9A:83:DF:F9:AB:BB:A6:2E:DB:AF:6F:2D:10:2B:F2:57:FD:71:2F:4D:9F:27:46:ED:8D`).

| File | Subject CN | SHA-256 certificate fingerprint |
|---|---|---|
| `EEEMIncommonDVG2C.crt` | InCommon Intermediate CA - DVG2C | `83:09:05:81:23:07:DF:14:C3:D9:D7:1B:9A:5A:83:24:79:40:85:7D:D2:0B:F6:D6:7F:64:93:D2:07:0D:A6:49` |
| `EEEMIncommonOVG2C.crt` | InCommon Intermediate CA - OVG2C | `BA:02:F2:F9:7B:A4:81:D1:9E:D4:90:6B:AB:56:02:A9:CE:1C:CE:5D:1F:36:2E:B5:EC:4F:9D:82:8E:F0:9F:FC` |
| `EEEMIncommonEVG2C.crt` | InCommon Intermediate CA - EVG2C | `A8:35:59:D8:92:F4:69:2D:A9:A0:88:A1:B7:59:77:30:15:D7:AA:6F:B2:B5:0B:18:C5:F9:F8:9C:C2:76:31:E1` |
| `EEEMIncommonIGTFOVG2C.crt` | InCommon RSA IGTF Server CA 4 | `F1:A7:8E:13:D7:AB:31:07:2E:22:39:18:D2:57:B5:41:01:0A:D9:3A:E6:D3:9F:3D:74:A0:D8:B2:EE:4C:3E:7D` |
| `EEEMIncommonDVG3C.crt` | InCommon Intermediate CA - DVG3C | `34:60:C0:2F:0B:4B:06:C2:73:9C:B0:DE:17:B4:10:62:B9:45:15:D8:37:65:2A:EB:FF:77:AE:87:E0:93:0C:FF` |
| `EEEMIncommonOVG3C.crt` | InCommon Intermediate CA - OVG3C | `56:6B:3A:F3:CB:66:63:A9:F9:E2:1E:EF:82:08:89:C2:D1:A4:EA:2F:7D:F0:B7:BB:0D:50:60:24:98:70:FA:08` |
| `EEEMIncommonEVG3C.crt` | InCommon Intermediate CA - EVG3C | `5F:2F:05:0F:9C:DD:92:8F:E5:01:02:24:47:33:CB:A7:EA:72:20:4D:9A:76:86:94:9C:E5:9E:40:2A:D1:AA:B9` |

## Assessment

These are 15 newly listed subordinate CA certificates, not newly observed roots. None of their subjects had a certificate in the 2026-10-30 corpus, so there is no prior same-subject certificate to compare for key reuse or re-issuance. The three issuing-root certificates named above are present in both snapshots and are byte-identical; the old corpus contained no removed files. The additions therefore do not show a trust-anchor rotation or a same-subject re-issue. They add subordinate issuance paths under existing roots; repository publication by itself does not show that a device trust store or DigiLocker pin set changed. The certificate issuance dates precede the repository `Last-Modified` date, so this snapshot establishes that the files were served by October 28, not when they first became available.

## Reproduction

`sha256sum -c emsign-repository/2026-11-02-full-corpus/SHA256SUMS.txt`

Certificate fingerprints above were independently decoded with `openssl x509 -inform DER -fingerprint -sha256 -subject -issuer -startdate -enddate` from the preserved certificate bytes.
