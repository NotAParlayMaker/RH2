import Main
import Lean.Elab.Command
import Lean.Util.CollectAxioms

open Lean in
run_cmd do
  let allowed : List Name := [``propext, ``Classical.choice, ``Quot.sound]
  let theorems : List Name :=
    [``riemannHypothesis, ``riemannZeta_eq_zero_re, ``LFunction_ne_zero_of_half_lt_re,
     ``LFunction_eq_zero_re, ``LFunction_eq_zero_re_of_isPrimitive]
  for name in theorems do
    unless (← getEnv).find? name |>.any (fun info => match info with
      | .thmInfo _ => true
      | _ => false) do
      throwError "{name} is not a theorem"
    let axioms := (← collectAxioms name).qsort Name.lt
    logInfo m!"{name}: {axioms.toList}"
    let unexpected := axioms.filter (fun axiomName => !allowed.contains axiomName)
    unless unexpected.isEmpty do
      logError m!"{name} depends on unexpected axioms: {unexpected.toList}"
