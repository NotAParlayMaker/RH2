import Mathlib
import Formalism.PeriodIntegrals.KerLat
import Formalism.PeriodIntegrals.UnitaryGroupMassFormula.IntegerCoordinatesZero

theorem kernel_lattice_t0_exists : PI.KerLat.ExistsTwoTorsionOffKernels :=
  PI.TwoDivisibility.main
