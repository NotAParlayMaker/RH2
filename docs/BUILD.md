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

After the full build, check the axioms:

```sh
cat > /tmp/Axioms.lean <<'LEAN'
import Main
#print axioms riemannHypothesis
#print axioms riemannZeta_eq_zero_re
#print axioms LFunction_ne_zero_of_half_lt_re
#print axioms LFunction_eq_zero_re
#print axioms LFunction_eq_zero_re_of_isPrimitive
LEAN
lake env lean /tmp/Axioms.lean
```

The good result is `propext`, `Classical.choice` and `Quot.sound` for each theorem. Any other axiom, and `sorryAx` in particular, means that the proof is not complete.

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

`lakefile.toml` sets `maxHeartbeats = 4000000` and `--tstack=400000`. Four proofs set `maxHeartbeats 0`. Do not lower these values, or some proofs can stop with a time out.
