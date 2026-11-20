# Source

## Origin

| Item | Value |
|---|---|
| Author | Levent Alpöge |
| Home page | https://alpo.ge |
| Note | https://alpo.ge/remark.pdf (4 pages, made 2026-11-20 19:52 +07) |
| Archive parts | https://alpo.ge/lean.tar.gz.part01 to https://alpo.ge/lean.tar.gz.part14 |
| Downloaded | 2026-11-20 |

The note gives the URLs of the parts in its first footnote.

## Hashes

The archive is the parts in order: `cat lean.tar.gz.part01 ... lean.tar.gz.part14 > lean.tar.gz`.

| File | Bytes | SHA-256 |
|---|---|---|
| `lean.tar.gz` | 239,275,554 | `9631b4f020199e580ba86178cb56c6e9b09f690c2369a80dc4334aa93f49c7fc` |
| `remark.pdf` | 245,114 | `3fc97784b71ddd44ff8aa0a177e99622a1c61b13cfa843a0989ee4a7a0cfeb8d` |

Parts 01 to 13 have 18,000,000 bytes each. Part 14 has 5,275,554 bytes. The SHA-256 of each part is in `manifests/parts.sha256`. The SHA-256 of each file of the tree is in `manifests/files.sha256`.

## What changed

Nothing in `lean/` changed. The archive has the top directory `lean/`, and this repository keeps it. The files outside `lean/` are ours.

The archive does not have the `.lake` directory or build output.

## Check

Run `scripts/verify-source.sh`. It exits with code 0 when the tree is the same as the release. The workflow `source` runs `sha256sum -c manifests/files.sha256` on each push.
