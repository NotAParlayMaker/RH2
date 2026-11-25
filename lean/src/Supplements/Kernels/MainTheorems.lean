import Development.AutomorphicArithmetic.CharacterBoxes.ClaimStrip
import Development.AutomorphicArithmetic.CharacterBoxes.MainConclusion

open Complex DirichletCharacter

theorem allChi : UpperTheory.EveryCharacter := UpperTheory.FinalTheorems.everyCharacter

theorem stripAll : Claim.Strip := Claim.strip allChi

theorem rhOfAll : RiemannHypothesis := Claim.zeta allChi

theorem critAll (N : ℕ) [NeZero N] (χ : DirichletCharacter ℂ N) (_ : χ.IsPrimitive) (s : ℂ)
    (h0 : 0 < s.re) (h1 : s.re < 1) (hz : LFunction χ s = 0) : s.re = 1 / 2 :=
  stripAll N χ s h0 h1 hz
