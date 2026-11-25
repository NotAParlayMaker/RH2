import Mathlib
import Formalism.PeriodIntegrals.VacEntire
import Formalism.PeriodIntegrals.UnitaryGroupMassFormula.VacuumEntire

theorem entireStatements_holds : PI.VacEntire.Target :=
  ⟨PI.VacEntire.UnitaryGroupMassFormula.iopEntire, PI.VacEntire.UnitaryGroupMassFormula.tensEntire⟩
