import Mathlib
import Formalism.PeriodIntegrals.LowCyc
import Formalism.PeriodIntegrals.KFinSmooth
import Formalism.PeriodIntegrals.UnitaryGroupMassFormula.LowerSmoothStability

theorem low_smooth_of_k_finite : PI.KFinSmooth → PI.LowSmooth := PI.UnitaryGroupMassFormula.LowSmooth.lowSmooth_of_kFinSmooth
