# Structure

This document describes the layout of `lean/`. The numbers come from a scan of the release on 2026-11-21. `lean/` has the same modules and lines as the release, but 781 of them have new paths (refer to [SOURCE.md](../SOURCE.md)). The toolchain in tamnd/riemann-agent makes them again with `rh index`.

## Package

| Item | Value |
|---|---|
| Package name | `tree` |
| Source directory | `lean/src` |
| Toolchain | `leanprover/lean4:v4.33.1` |
| Mathlib | `0df444a360eaa60ab8c11dca51a86af692955474` |
| Lean options | `autoImplicit = false`, `relaxedAutoImplicit = false`, `maxSynthPendingDepth = 3`, `maxHeartbeats = 4000000`, `--tstack=400000` |

## Libraries

`lean/lakefile.toml` defines 11 libraries. `GroundTheory` and `GroundTheoryFields` share the directory `src/GroundTheory`. `GroundTheoryFields` holds `LocalFields` and `GlobalFields` and sets `synthInstance.maxHeartbeats = 400000`.

| Library | Files | Lines | Main parts |
|---|---|---|---|
| `Development` | 141,928 | 12,374,591 | AbelianVarietyTheory (99,187 files), AutomorphicArithmetic (18,431), AutomorphicSpectrum (15,147), WeilBound (7,051), EtaleCohomology (1,398), ResolutionOfSingularities (499), DiscreteGroups (215) |
| `Formalism` | 18,254 | 3,219,002 | LocalToGlobal (5,501), PeriodIntegrals (4,350), SharpRestriction (3,093), HermitianCurvature (1,922), GL3MeanSquares (440), ThetaLogCoordinates (292), WachLatticeTwists (262) and many small parts |
| `GroundTheory` and `GroundTheoryFields` | 8,507 | 1,127,645 | HeightsAndTheta (6,410), AutomorphicForms (542), ProfiniteCohomology (450), GlobalFields (384), PAdicHodge (226), ArithmeticGeometry (218), LocalFields (159) |
| `ReciprocityTheory` | 3,845 | 566,861 | ReductiveGroups (2,799), L2DbarEstimates (227), AnalyticForms (192), DualLattices (183), SemistableReduction (119), ClassFieldTheory (91) |
| `CompanionTheory` | 2,027 | 196,245 | SpectralGeometry (1,254), AutomorphicTheory (457), RealGroups (155), HarishChandraModules (130) |
| `PositivityTheory` | 449 | 55,579 | AutomorphicForms (445), PublishedTheorems (3) |
| `Lemmata` | 167 | 9,399 | small lemmas |
| `BuildAid` | 5 | 25 | settings for library suggestions (see below) |
| `Supplements` | 3 | 25 | the kernel of the main theorems |
| `Main` | 2 | 30 | `Main.lean` and `Statements.lean` |

The release has about 1,060,800 declarations: 784,087 `theorem`, 34,663 `lemma`, 212,815 `def`, 13,202 `abbrev`, 8,286 `structure`, 7,598 `instance`, 121 `inductive` and 43 `class`. The mean file has about 99 lines. Many files hold one theorem. The source has no comments.

## Imports

Each of the 175,187 modules is in the import closure of `Main`. The longest import chain from `Main` has 203 modules. The modules import 344 different Mathlib modules directly.

## Names and files

A file name does not always give the namespace. For example, `UpperTheory.EveryCharacter` is in `src/Development/AutomorphicArithmetic/CharacterBoxes/EveryCharacter.lean`. Many declarations use a full name at the top level. Others are in `namespace` blocks. Some root namespaces are not library names, for example `UpperTheory`, `GlobalTheory` and `SelfIntersectionVolumeEstimates`.

The five files `BuildAid/D1.lean` to `D5.lean` each run one command. The command adds a namespace to the deny list of library suggestions (`Lean.LibrarySuggestions.nameDenyListExt`). The namespaces are `CompanionTheory`, `CrystallineSemistableComparison`, `GlobalTheory`, `PositivityTheory` and `UpperTheory`. This changes which lemmas a suggestion tactic shows. It does not change a proof or the kernel check.

## The top of the proof

The proof goes down from `Main` in this order:

1. `Main.lean`: `riemannHypothesis : RiemannHypothesis := rhOfAll`.
2. `Supplements/Kernels/MainTheorems.lean`: `rhOfAll := Claim.zeta allChi` and `stripAll := Claim.strip allChi`, with `allChi := UpperTheory.FinalTheorems.everyCharacter`.
3. `Development/AutomorphicArithmetic/CharacterBoxes/EveryCharacter.lean`: `UpperTheory.EveryCharacter` says that `DirichletCharacter.LFunction χ s ≠ 0` for each Dirichlet character χ and each s with `1 / 2 < s.re`, except χ = 1 with s = 1.
4. `Development/AutomorphicArithmetic/CharacterBoxes/ClaimStrip.lean`: `Claim.strip` reflects a zero in the critical strip to `1 - s` with the functional equation of the completed L-function, for every Dirichlet character. `Claim.zeta` does the same for ζ with the completed zeta function. `Claim.HalfPlane` is the same proposition as `UpperTheory.EveryCharacter`. These proofs use Mathlib only. (The release also had a second copy of this step in `Formalism/GammaFactorNonvanishing`; `patches/0001-single-top-bridge.patch` removes it.)
5. `Development/AutomorphicArithmetic/CharacterBoxes/MainConclusion.lean`: `everyCharacter` comes from `everyCharacter_of_row` and `UpperTheory.Gal.Int.galoisLocalGlobalStrong_recParameter`.
6. `Development/AutomorphicArithmetic/ThetaCorrespondence/ThetaPairLifts/ThirdPlaceSeries/EveryCharacterOfLiteratureOfVWin.lean`: `every_character_of_literature_of_vWin` joins many named results.

The names in step 6 say "literature" and "published", but the code does not assume these results. The structure `UpperTheory.LiteratureTheorems.OpenLiteratureStatements` has three fields, and `MainConclusion.lean` gives a proof for each. Each named result is a theorem with a proof in the release, for example `PositivityTheory.PfDR.deligneRibet_holds` for the Deligne-Ribet theorem.

The written explanation of each step is in tamnd/riemann and at https://riemann.tamnd.com.

## Exceptional-zero input

The [Landau–Page comparison](LANDAU-PAGE.md) traces the rational prime-counting hypothesis used in the short-interval argument and compares it with the shifted-prime estimate of Krause, Mousavi, Tao, and Teräväinen.
