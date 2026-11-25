import Development.WeilBound.RepresentationTheoryGL.UnitaryDualProof.GenericIrreducibility.CentralProd2
import Development.WeilBound.RepresentationTheoryGL.UnitaryDualProof.GenericIrreducibility.FirstPairExistence
import Development.WeilBound.RepresentationTheoryGL.UnitaryDualProof.GenericIrreducibility.IrreducibleFactors
import Development.WeilBound.RepresentationTheoryGL.UnitaryDualProof.GenericIrreducibility.ContragredientSwap
import Development.WeilBound.RepresentationTheoryGL.UnitaryDualProof.GenericIrreducibility.ThetaProducts
import Development.WeilBound.RepresentationTheoryGL.UnitaryDualProof.GenericIrreducibility.CentralCharacterTheta
import Development.WeilBound.RepresentationTheoryGL.UnitaryDualProof.GenericIrreducibility.CentralCharacterZero

namespace PositivityTheory.RgUd.Exp.Final

open PositivityTheory.RgUd.Exp

variable (k : Type) [Field k] [ValuativeRel k] [TopologicalSpace k] [IsNonarchimedeanLocalField k]

theorem expBound (hL : ExpLow k) : ExpBound k :=
  PositivityTheory.RgUd.Exp.expBound_of k
    (Move2.moveLast k (Fact.factorIrr k) (Comm.comm2Irr k)) (Move2.moveFirst k (Fact.factorIrr k) (Comm.comm2Irr k))
    (ThetaPf.thetaProd k) (thetaFacts k) (centralProd2 k) hL

theorem expBound_of : ExpLow k → ExpBound k := expBound k

end PositivityTheory.RgUd.Exp.Final
