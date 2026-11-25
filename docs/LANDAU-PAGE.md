# Landau–Page comparison for the rational prime-counting input

Krause, Mousavi, Tao, and Teräväinen use a possible exceptional Dirichlet zero to correct the expected prime count on the progression `qy + 1`. RH2 has a related exceptional-character estimate for prime ideals in ray classes. The comparison below identifies the input supplied to RH2's short-interval argument and the extra work needed to use the paper as a source for that input. [Paper, Definition 2.3 and Lemma 2.1](https://arxiv.org/abs/2608.19525v1)

## Where the RH2 estimate enters

1. `adm8` assumes the rational estimate `SiegelZeroExceptionalCharacter ℚ (TieQ c1) C0 Cr cr cQ` and separately assumes `Q4` for the host field. `FamilyTemperatureAsymptotic` requires common positive constants and supplies `adm8` across the family. It is the eighth conjunct of `AdmF`. [Single-object assumption](../lean/src/Formalism/SharpRestriction/GlobalSchurBounds/ShortIntervalPrimes.lean#L149) · [Family assumption](../lean/src/Formalism/SharpRestriction/GlobalSchurBounds/ShortIntervalPrimes.lean#L377)
2. `lemma_two_three_rat_of_Q4` takes the rational exceptional-character estimate as a hypothesis and derives `ShortIntervalLowerBound ℚ`. The proof supplies rational ray-class cardinality and degree-two bounds before applying the general short-interval argument. [Rational specialization](../lean/src/Formalism/SharpRestriction/GlobalSchurBounds/FirstClaimLemmaTwoFourOfLemmaTwoThree.lean#L1793)
3. `ratDict_holds` supplies a comparison with rational primes by mapping prime ideals to their norms. `primes_in_progressions_short_intervals` converts the degree-one prime ideal lower bound into a lower bound for primes in a reduced residue class, for moduli at least three. This comparison uses an inequality between counts. [Rational dictionary](../lean/src/Formalism/SharpRestriction/GlobalSchurBounds/FirstClaimLemmaTwoFourOfLemmaTwoThree.lean#L1527) · [Progression bound](../lean/src/Formalism/SharpRestriction/GlobalSchurBounds/FirstClaimLemmaTwoFourOfLemmaTwoThree.lean#L1551)

This traces the estimate to the hypotheses of the short-interval argument. Establishing that those hypotheses are supplied along a particular route to `Main` requires following that route's proof terms.

## Compare the statements

| Feature | Paper, Lemma 2.1 | RH2, rational specialization |
|---|---|---|
| Count | Average of the von Mangoldt weights on `qy + 1` for `1 ≤ y ≤ T`. Equivalently, the weighted progression count up to `X = qT + 1`, divided by `T`. | Unweighted prime ideal count `piCC` up to `X` in every coprime ray class. |
| Moduli and scales | For fixed `A ≥ 1` and large `N`, the cutoff is `Q̃ = exp((log N)^c₀)` with `0 < c₀ < 1/11`. The lemma requires `q ≤ Q̃` and `N^(1/A) ≤ qT ≤ N^A`. | Requires `B^C0 ≤ X`, where `B = Bmod ℚ qq`. For `qq = idQ q`, Lean proves `B = 4q`. This permits a power range of moduli. |
| Exceptional zero | Takes a primitive real character of conductor at most `Q̃` with real zero `β ≥ 1 − 1/(1000 log Q̃)`. Its correction is present only if that conductor divides `q`. | For each modulus the ray-class correction can be zero. The real-character branch requires `1/2 ≤ β < 1` and `1 − β ≥ cQ/(B² log B)`. `TieQ` links the correction to an actual Dirichlet L-function zero and specifies the zero-exclusion or uniqueness conditions in a window defined by `1 − c1/log B`. |
| Main term and error | After normalization by `T`, the main term is `q/φ(q)` times `1 − 1_{qSiegel divides q} X^(β−1)/β`, with an additive error `O_A(exp(−c_A sqrt(log N)))`. | The main term is `(Li(X) − θ(I₀) Li(X^β))/grCard`, with an error bounded by that main term times `Cr exp(−cr log X/log B) + Cr exp(−cr sqrt(log X))`. |

[Paper, §2.1 and equation (2.5)](https://arxiv.org/abs/2608.19525v1) · [RH2 error function](../lean/src/Formalism/SharpRestriction/GlobalSchurBounds/ShortIntervalPrimes.lean#L16) · [RH2 estimate](../lean/src/Formalism/SharpRestriction/GlobalSchurBounds/ShortIntervalPrimes.lean#L50) · [RH2 character correspondence](../lean/src/Formalism/SharpRestriction/GlobalSchurBounds/ShortIntervalPrimes.lean#L73) · [Rational modulus identity](../lean/src/Formalism/SharpRestriction/GlobalSchurBounds/FirstClaimLemmaTwoFourOfLemmaTwoThree.lean#L1540)

## What a formal bridge would need

- Start with the identity ray class and the common subexponential range. Relate that class and its cardinality to reduced residues and `φ(q)`. The existing `RatDict` is a lower-bound transfer for short intervals.
- Control the prime-power contribution in the von Mangoldt sum and use partial summation to obtain the logarithmic-integral main term. Track uniformity in the summation variable and the error relative to the exceptional-corrected main term.
- Match the induced primitive character and conductor condition to `TieQ`. An estimate covering every reduced residue class and RH2's wider modulus range would require additional input beyond the stated Lemma 2.1.

Conversely, RH2's exported right-half-plane nonvanishing, if verified, would exclude the paper's exceptional zero for sufficiently large `N), when its cutoff exceeds `1/2`. The paper's density argument would still need its Gowers-norm comparison and density increment estimates. [RH2 nonvanishing theorem](../lean/src/Main.lean#L6) · [Paper, §5](https://arxiv.org/abs/2608.19525v1)
