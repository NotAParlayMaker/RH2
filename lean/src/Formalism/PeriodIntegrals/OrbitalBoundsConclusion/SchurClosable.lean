import Mathlib
import Formalism.LocalToGlobal.IndefiniteReal.HaarTransfer.SchurClosable
import Formalism.PeriodIntegrals.UnitaryGroupMassFormula.SchurUnitaryInner

theorem schur_closable : Formalism.IndefR.Leaf.SchurClosable :=
  PI.UnitaryGroupMassFormula.SchurClosable.Main.schurClosable
