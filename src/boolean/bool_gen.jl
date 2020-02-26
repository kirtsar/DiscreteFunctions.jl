"""
Generates all boolean function of arity = n
"""
struct BooleanGenerator{F} <: DiscreteFunctionGenerator
    itr :: UnitRange{Int}
    f :: BooleanFunction{F}
end

const BoolGen = BooleanGenerator
# from arity
function BoolGen(arity :: Int)
    itr = 0 : (2^(2^arity) - 1)
    f = BooleanFunction(arity)
    return BoolGen(itr, f)
end
# from bool cube
BoolGen(bc :: BooleanCube) = BoolGen(ndims(bc))
# iteration utilities #
function itstep(ctr, gen :: BoolGen)
    value = ctr[1]
    state = ctr[2]
    fill_bits!(gen.f.m, value)
    return (gen.f, state)
end
itstep(:: Nothing, gen :: BoolGen) = nothing
Base.iterate(gen :: BoolGen) = itstep(iterate(gen.itr), gen)
Base.iterate(gen :: BoolGen, state) = itstep(iterate(gen.itr, state), gen)