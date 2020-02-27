abstract type BooleanGenerator <: DiscreteFunctionGenerator end
const BoolGen = BooleanGenerator

"""
Generates all boolean function of arity = n
"""
struct BooleanFunctionGenerator{T, F} <: BoolGen
    itr :: UnitRange{T}
    farr :: Vector{F}
end

struct BooleanMapGenerator{T, F} <: BoolGen
    itr :: T
    farr :: Matrix{F}
end

const BFGen = BooleanFunctionGenerator
const BMGen = BooleanMapGenerator
# from arity
function BFGen(arity)
    # we want to iterate over all functions
    itr = 0 : (2^(2^arity) - 1)
    farr = zeros(Int, 2^arity)
    return BFGen(itr, farr)
end

function BMGen(arity, nfuns)
    # we want to iterate over all functions
    fun_itr = 0 : (2^(2^arity) - 1)
    itr = product(fill(fun_itr, nfuns)...) 
    farr = zeros(Int, nfuns, 2^arity)
    return BMGen(itr, farr)
end

BFGen(bc :: BCube) = BFGen(ndims(bc))

nfuns(gen :: BFGen) = 1
nfuns(gen :: BMGen) = size(gen.farr)[1]
arity(gen :: BFGen) = Int(log2(length(gen.farr)))
arity(gen :: BFGen) = Int(log2(size(gen.farr)[2]))

# iteration utilities #
function onestep(ctr, gen :: BFGen)
    value = ctr[1]
    state = ctr[2]
    fill_bits!(gen.farr, value)
    f = BoolFun(gen.farr)
    return (f, state)
end

function onestep(ctr, gen :: BMGen)
    value = ctr[1]
    state = ctr[2]
    for i in 1 : nfuns(gen)
        fill_bits!(view(gen.farr, i, :), value[i])
    end
    f = BoolMap(gen.farr)
    return (f, state)
end

onestep(:: Nothing, gen :: BFGen) = nothing
onestep(:: Nothing, gen :: BMGen) = nothing
Base.iterate(gen :: BoolGen) = onestep(iterate(gen.itr), gen)
Base.iterate(gen :: BoolGen, state) = onestep(iterate(gen.itr, state), gen)