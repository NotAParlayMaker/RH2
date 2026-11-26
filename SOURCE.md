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

Parts 01 to 13 have 18,000,000 bytes each. Part 14 has 5,275,554 bytes. The SHA-256 of each part is in `manifests/parts.sha256`. The SHA-256 of each file of the release is in `manifests/release-files.sha256`. The SHA-256 of each file of `lean/` in this repository is in `manifests/files.sha256`.

## What changed

The archive has the top directory `lean/`, and this repository keeps it. The files outside `lean/` are ours.

`lean/` is the release after one mechanical step, `scripts/restructure.py`. In the release, 781 directories hold exactly one `.lean` file and nothing else, for example `Lemmata/MiscLemmasN/Imports.lean`. The script replaces each such directory by its file (`Lemmata/MiscLemmasN.lean`) and changes each `import` of the old module name to the new one. It repeats this until no such directory is left. It keeps a directory when a file of the same name is already next to it, or when the move would put the module in another lakefile library.

The step changes only file paths and `import` lines. No declaration, namespace, proof or Lean option changes, and each module stays in its library, so the elaborated environment has the same declarations. The tree still has 175,187 modules. `manifests/moves.tsv` lists each old and new path. Apart from the patches, all other files are byte for byte the same as the release; 3,492 of them differ only in `import` lines.

After the layout step, the patches in `patches/` are applied in order. Each patch is a reviewable diff with a header that says why. `0001-single-top-bridge.patch` routes the five exported theorems through the single Mathlib-level bridge in `ClaimStrip.lean`, and deletes the duplicate bridge in `Formalism/GammaFactorNonvanishing` (two files, 94 lines). The statements of the exported theorems do not change. `0002-remove-unused-bridge.patch` deletes a third copy of the same bridge in `CharacterBoxes/RiemannHypothesisOfEveryCharacter.lean`, the unused theorem `UpperTheory.FinalTheorems.riemannHypothesis` that was its only use, and the unused `claimAll` (28 lines; no import line changes). `0003-bound-uniformizer-heartbeats.patch` removes `set_option maxHeartbeats 0` from two proofs that need less than a quarter of the project limit, and `0004-bound-last-heartbeats.patch` removes the last two, which need less than 40% of it.

The script checked that no source file refers to a module name outside an `import` line (no `open private ... from`, `_private`, or module-name lookups in meta code).

The archive does not have the `.lake` directory or build output.

## Check

Run `scripts/verify-source.sh`. It downloads the release, checks it against `manifests/release-files.sha256`, applies `scripts/restructure.py`, and exits with code 0 when the result is the same as `lean/`. The workflow `source` runs the offline part on each push: it checks `manifests/files.sha256`, runs `scripts/restructure.py --check`, reverses the patches, undoes the layout with `--undo manifests/moves.tsv`, and checks the result against `manifests/release-files.sha256`, then applies the layout and the patches again and compares the result with `lean/`. So each push shows that `lean/` is the release after the script and the patches, without a download. The download from alpo.ge runs every week.
