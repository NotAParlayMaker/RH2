import Statements
import Development.AutomorphicArithmetic.CharacterBoxes.ClaimStrip

namespace RH2

/-- Right-half-plane nonvanishing implies the critical-strip result for every character. -/
theorem strip_of_halfPlane (halfPlane : DirichletLNonvanishingRightOfHalf) :
    DirichletLZerosOnLine :=
  Claim.strip halfPlane

/-- The all-character result specializes to primitive characters. -/
theorem primitiveStrip_of_strip (strip : DirichletLZerosOnLine) :
    PrimitiveDirichletLZerosOnLine := by
  intro N _ χ _ s h₀ h₁ hz
  exact strip N χ s h₀ h₁ hz

/-- The same nonvanishing hypothesis gives Mathlib's Riemann Hypothesis. -/
theorem riemannHypothesis_of_halfPlane (halfPlane : DirichletLNonvanishingRightOfHalf) :
    RiemannHypothesis :=
  Claim.zeta_iff.mp (Claim.zeta halfPlane)

end RH2
