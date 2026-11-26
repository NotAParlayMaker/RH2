# Build

## Needs

- elan, the Lean toolchain manager. Lake reads `lean/lean-toolchain` and installs `leanprover/lean4:v4.33.1`.
- git and curl.
- Much time, memory and disk. Refer to the estimate below.

## Steps

```sh
cd lean
lake exe cache get        # download the built Mathlib for commit 0df444a3
lake build Statements     # a fast check: the statements on top of Mathlib
lake build                # the full build
```

## Proof audit

With the Mathlib cache available, run these commands from the repository root.

```sh
scripts/audit-proof.sh
scripts/audit-proof.sh --full
scripts/audit-proof.sh --full /absolute/path/to/lean4lean
```

- The default builds `Statements` and checks that the zeta statement agrees definitionally with Mathlib's `RiemannHypothesis`. It also checks the quantifiers, hypotheses and conclusions of the three Dirichlet L-function statements against the formulas in [the statement audit](../scripts/audit-statements.lean). In particular, the right-half-plane statement excludes the principal character at `s = 1`, and both zeros-on-the-line statements apply in the open critical strip.
- `--full` also builds `Main` and prints the transitive axioms of each of its five exported theorems. The audit fails if any axiom falls outside `propext`, `Classical.choice` and `Quot.sound`.
- Passing a compatible [lean4lean](https://github.com/digama0/lean4lean) executable also replays `Main` and its imports in the independent checker. Build the checker outside this repository with a revision compatible with `lean/lean-toolchain`. The full build and the independent replay can each require substantial resources.

### Interpreting audit results

| Export | Mathematical scope |
|---|---|
| `riemannHypothesis`, `riemannZeta_eq_zero_re` | Zeta zeros other than the negative even integers and the point `s = 1` have real part `1/2`. |
| `LFunction_ne_zero_of_half_lt_re` | For every Dirichlet character of positive modulus, its L-function is nonzero where `Re(s) > 1/2`, with the principal character at `s = 1` excluded. |
| `LFunction_eq_zero_re` | For every Dirichlet character of positive modulus, a zero in `0 < Re(s) < 1` has real part `1/2`. |
| `LFunction_eq_zero_re_of_isPrimitive` | The same critical-strip conclusion for primitive characters. |

Record the repository commit, Lean version, and each completed stage when sharing results. Statement checking establishes the propositions being built. The full build checks the proof terms, the axiom report records their assumptions, and independent replay checks the compiled declarations in a second implementation.

## Estimate

Nobody has published a time for the full build yet. This estimate is a guess, and the first build will replace it.

| Item | Estimate |
|---|---|
| Lines to build | about 17.4 million, in 175,187 files |
| Time on 64 cores | 5 to 10 hours |
| Time on 8 cores | 2 to 4 days |
| Memory | 2 to 6 GB for each Lean process |
| Disk for `.lake` | 20 to 50 GB, with Mathlib |

The standard GitHub runners cannot do the full build. The workflow `build-small` builds `Statements` only.

## Options

`lakefile.toml` sets `maxHeartbeats = 4000000` and `--tstack=400000`. No proof sets `maxHeartbeats 0` (the release had four; refer to `patches/0003-bound-uniformizer-heartbeats.patch` and `patches/0004-bound-last-heartbeats.patch`). Do not lower these values, or some proofs can stop with a time out.
