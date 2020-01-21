module DF

using Base.Iterators

import Base.show, Base.first, Base.last, Base.iterate
import Base.size, Base.length, Base.ndims
import Base.summary, Base.getindex, Base.setindex!

include("finite_sets.jl")
include("types.jl")
include("show_utils.jl")
include("apply_func.jl")
include("helper_utils.jl")
include("generators.jl")

end # module
