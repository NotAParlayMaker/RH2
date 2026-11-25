import Formalism.PeriodIntegrals.UnitaryGroupMassFormula.IntegerProductCast
import Formalism.PeriodIntegrals.OrbitalBoundsConclusion.QmRowForm

theorem quantum_minor_star : PI.QmStar :=
  PI.UnitaryGroupMassFormula.QmStar.qmStar_of quantum_minor_row_form
