import Development.WeilBound.RepresentationTheoryGL.TubeMeasures.DisjointTubes.ProductMapEquality
import Development.WeilBound.RepresentationTheoryGL.TubeMeasures.DisjointTubes.LevelStabilisers
import Development.WeilBound.RepresentationTheoryGL.TubeMeasures.DisjointTubes.UpperFactors
import Development.WeilBound.RepresentationTheoryGL.TubeMeasures.DisjointTubes.InverseMultiplication
import Development.WeilBound.RepresentationTheoryGL.TubeMeasures.DisjointTubes.ExponentialThreeBound
import Development.WeilBound.RepresentationTheoryGL.TubeMeasures.DisjointTubes.BoxExistence
import Development.WeilBound.RepresentationTheoryGL.TubeMeasures.DisjointTubes.MeasureSumBounds
import Development.WeilBound.RepresentationTheoryGL.TubeMeasures.DisjointTubes.FormalDegreeRankTwo
import Development.WeilBound.RepresentationTheoryGL.TubeMeasures.DisjointTubes.ConstantSupremum.Tube0

namespace MainStatements.Tam.Plug

theorem up : UpSt := MainStatements.Tam.up MainStatements.Tam.vol MainStatements.Tam.stab MainStatements.Tam.num

theorem low : LowSt := MainStatements.Tam.low MainStatements.Tam.vol MainStatements.Tam.stab MainStatements.Tam.num

theorem comp : CompSt := MainStatements.Tam.comp (tube0 MainStatements.Tam.vol MainStatements.Tam.stab MainStatements.Tam.idx) MainStatements.Tam.num

theorem size : SizeSt := MainStatements.Tam.size

end MainStatements.Tam.Plug
