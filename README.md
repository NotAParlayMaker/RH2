# riemann-lean

This repository holds the Lean 4 source of the claimed proof of the Riemann Hypothesis by Levent Alpöge. The source is the release of 2026-11-20 from https://alpo.ge. Files that were alone in a directory now replace that directory, and the `import` lines follow. Proof changes are kept as reviewable patches in `patches/`. Refer to [SOURCE.md](SOURCE.md).

The author describes the work in the note [remark.pdf](https://alpo.ge/remark.pdf). The note says that the Lean code proves the Riemann Hypothesis and the Generalized Riemann Hypothesis for Dirichlet L-functions. This repository does not make that claim. It keeps the source in a form that people can read, cite, search and build.

The written explanation of the proof is in [tamnd/riemann](https://github.com/tamnd/riemann). The site is https://riemann.tamnd.com. The toolchain is in [tamnd/riemann-agent](https://github.com/tamnd/riemann-agent).

## Status

| Check | Result |
|---|---|
| The tree is the same as the release | yes, after one mechanical step that flattens one-file directories; see [SOURCE.md](SOURCE.md) and `manifests/release-files.sha256` |
| Text scan for `sorry`, `admit`, `axiom`, `native_decide` and other escape hatches | no hits, see [docs/SCAN.md](docs/SCAN.md) |
| A reading of the source: every input of the trunk theorem comes from a proved term | yes, see [the trust report](https://riemann.tamnd.com/trust/) |
| Full build with the pinned toolchain | not done yet |
| `#print axioms riemannHypothesis` | not done yet |
| Replay in a second kernel | not done yet |

The checks that need a build are work of milestone M2 of tamnd/riemann-agent. Until they pass, treat the result as a claim.

## Content

| Path | Content |
|---|---|
| `lean/` | the release, with one-file directories flattened by `scripts/restructure.py` |
| `lean/src/Main.lean` | the five main theorems |
| `lean/src/Statements.lean` | four statements about Dirichlet L-functions, on top of Mathlib |
| `docs/STRUCTURE.md` | the libraries, the entry points and the top of the proof |
| `docs/BUILD.md` | how to build, and the expected cost |
| `docs/SCAN.md` | the results of the text scan |
| `SOURCE.md` | where the release comes from, and the hashes |
| `NOTICE.md` | copyright and licence status |
| `CITATION.cff` | how to cite the release |
| `manifests/` | SHA-256 of each part, of the archive and of each file |
| `scripts/verify-source.sh` | download the release again and compare it with this tree |
| `scripts/scan.sh` | run the text scan |

## The main theorems

`lean/src/Main.lean` has these theorems:

```lean
theorem riemannHypothesis : RiemannHypothesis := rhOfAll
theorem riemannZeta_eq_zero_re : RiemannZetaZerosOnLine := rhOfAll
theorem LFunction_ne_zero_of_half_lt_re : DirichletLNonvanishingRightOfHalf := allChi
theorem LFunction_eq_zero_re : DirichletLZerosOnLine := claimAll.2.1
theorem LFunction_eq_zero_re_of_isPrimitive : PrimitiveDirichletLZerosOnLine := critAll
```

`RiemannHypothesis` is the definition in Mathlib. The other four statements are in `lean/src/Statements.lean`.

## Read the proof

- The [proof chapters](https://riemann.tamnd.com/proof/) explain the top of the proof in words. There are 12 chapters, from the statement of RH down to the theta lifts. Each chapter gives the definitions and theorems of its part, with the Lean name under each statement and a proof in words.
- The [handbook](https://github.com/tamnd/riemann-handbook/releases) has the same text, the background and the development volumes, as PDF and EPUB.
- The [trust report](https://riemann.tamnd.com/trust/) says what is checked and what is not.

## Size

The release has 175,187 Lean files, about 17.4 million lines and about 1.06 million declarations. Each module is in the import closure of `Main`. The source has no comments. Refer to [docs/STRUCTURE.md](docs/STRUCTURE.md).

## Build

The project uses Lean `v4.33.1` and Mathlib at commit `0df444a360eaa60ab8c11dca51a86af692955474`.

```sh
cd lean
lake exe cache get
lake build
```

The full build is large. Refer to [docs/BUILD.md](docs/BUILD.md) before you start it.

## Verify the source

```sh
scripts/verify-source.sh
```

The script downloads the 14 parts from https://alpo.ge, checks the SHA-256 of each part and of the archive, unpacks the archive in a temporary directory and compares each file with this tree.

## Cite

Cite the release with the data in [CITATION.cff](CITATION.cff). GitHub shows a "Cite this repository" button for it.

## Licence

The release has no licence. Copyright stays with the author. Refer to [NOTICE.md](NOTICE.md).
