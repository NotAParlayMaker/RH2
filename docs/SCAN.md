# Scan

`scripts/scan.sh` looks in `lean/src` for each way to put a fact into a Lean proof without a kernel check. The workflow `scan` runs it on each push. The script fails when a count is more than the allowed count in this table.

| Pattern | What it finds | Count | Allowed | Note |
|---|---|---|---|---|
| `sorry` | a proof that is not complete | 0 | 0 | |
| `admit` | the same as `sorry` | 0 | 0 | |
| `sorryAx` | the axiom behind `sorry`, used by name | 0 | 0 | |
| `axiom` | a new axiom | 0 | 0 | |
| `native_decide`, `ofReduceBool`, `trustCompiler` | a proof that trusts the compiler | 0 | 0 | |
| `implemented_by`, `@[extern]` | code that replaces a definition at run time | 0 | 0 | |
| `unsafe` | code that the kernel does not check | 0 | 0 | |
| `opaque` | a constant without a visible value | 0 | 0 | |
| `skipKernelTC` | an option that stops the kernel check | 0 | 0 | |
| `run_cmd` | a command that runs meta code | 5 | 5 | `BuildAid/D1.lean` to `D5.lean`; each one adds a namespace to the deny list of library suggestions |
| `initialize` | code that runs when a module loads | 0 | 0 | |
| `elab`, `macro`, `syntax` | new syntax or tactics | 26 | 26 | local tactic macros, for example `fin_index_simp`, `lbt`, `jet_tac`, `meq`; each one expands to normal tactics |
| `maxHeartbeats 0` | no time limit for one proof | 2 | 2 | no effect on soundness; `patches/0003-bound-uniformizer-heartbeats.patch` removed two that were not needed |

## Limits

A text scan cannot show that a proof uses no axiom. Meta code can add a declaration in other ways. Only these two checks can settle the question:

1. `#print axioms riemannHypothesis` on the built environment. Refer to [BUILD.md](BUILD.md).
2. A replay of the built environment in a kernel, for example with `lean4checker`.

The results of these checks go into the README of this repository and to https://riemann.tamnd.com/trust/.
