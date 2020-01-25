module DF

using Base.Iterators
import IterTools: nth

import Base: show, first, last, iterate, size, length, ndims,
              summary, getindex, setindex!, ∘
#import Base.∘

export Segment, DirectProduct, BooleanCube
export DiscreteFunction, ResidueFunction, ExtendedResidueFunction, BooleanFunction
export FunProduct, FunTupling
export table, tablegen, tabledict
export domain, codomain
export BooleanGenerator, ResidueGenerator, ExtendedResidueGenerator
export FunProductGenerator, FunTuplingGenerator

# short names
export DProd, BCube
export DFun, ResFun, ExtFun, BoolFun, FProd, FTuple
export BoolGen, ResGen, ExtGen, FTGen, FPGen


include("finite_sets.jl")
include("types.jl")
include("show_utils.jl")
include("apply_func.jl")
include("helper_utils.jl")
include("generators.jl")
include("compositions.jl")

end # module
