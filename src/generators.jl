abstract type DiscreteFunctionGenerator end
abstract type AbstractResidueGenerator <: DiscreteFunctionGenerator end

const DFGen = DiscreteFunctionGenerator
const ARGen = AbstractResidueGenerator

# structures -- generators
"""
Generates all boolean function of arity = n
"""
struct BooleanGenerator{F} <: DiscreteFunctionGenerator
    itr :: UnitRange{Int}
    f :: BooleanFunction{F}
end

"""
Generates all function of type 
{0, …, from -1} → {0, …, to - 1}
"""
struct ResidueGenerator <: ARGen
    itr :: UnitRange{Int}
    f :: ResidueFunction
    from :: Int
    to :: Int
end

"""
generate all functions of the type:
ℤ_k1 × … × ℤ_km → ℤ_l
"""
struct ExtendedResidueGenerator{T, N} <: ARGen
    itr :: UnitRange{Int}
    f :: ExtendedResidueFunction{T, N}
    from :: NTuple{N, Int}
    to :: Int
end

"""
generate all product-type functions:
D1 × … × Dk → R1 × … × Rk
"""
struct FunProductGenerator{IT, N, T, D, R} <: DFGen
    itr :: IT
    f :: FunProduct{N, T, D, R}
end

"""
generate all tuple-type functions: (f1, ..., fn)
D1 × … × Dk → R1 × … × Rn
fi : D1 × … × Dk → Ri
"""
struct FunTuplingGenerator{IT, N, T, D, R} <: DFGen
    itr :: IT
    f :: FunTupling{N, T, D, R}
end

const BoolGen = BooleanGenerator
const ResGen = ResidueGenerator
const ExtGen = ExtendedResidueGenerator
const FTGen = FunTuplingGenerator
const FPGen = FunProductGenerator
const FXGens = Union{FPGen, FTGen}


# construction of generators #


# Boolean generators #
# from arity
function BoolGen(arity :: Int)
    itr = 0 : (2^(2^arity) - 1)
    f = BooleanFunction(arity)
    return BoolGen(itr, f)
end
# from bool cube
BoolGen(bc :: BooleanCube) = BoolGen(ndims(bc))


# Residue generators #
# from two integers [0 .. from-1] → [0 .. to-1]
function ResGen(from :: T, to :: T) where T <: Integer
    itr = 0 : (to^from - 1)
    f = ResFun(from, to)
    return ResGen(itr, f, from, to)
end
#from two segments
ResGen(s1 :: T, s2 :: T) where T <: Segment = ResGen(length(s1), length(s2))


# Extended Residue generators #
# from tuple and number
function ExtGen(from :: NTuple{N}, to) where N
    num_from = prod(from)
    itr = 0 : (to^num_from - 1)
    f = ExtendedResidueFunction(from, to)
    return ExtGen(itr, f, from, to)
end
# from domain and codomain
ExtGen(dom, codom) where N = ExtGen(size(dom), length(codom))
# from domain and number
ExtGen(dom, to) where N = ExtGen(dom, segment(to))


# Function Product generators #
# from domain and codomain
function FPGen(dom :: AbstractProduct, codom :: AbstractProduct)
    n = ndims(dom)
    funs = Tuple(ResFun(dom[i], codom[i]) for i in 1 : n)
    tup = Tuple(nfuns(dom[i], codom[i]) for i in 1 : n)
    itr = Iterators.product(Segment.(tup)...)
    f = FunProduct(funs)
    return FPGen(itr, f)
end

# from two tuples
function FPGen(from :: NTuple{N, Int}, to :: NTuple{N, Int}) where N
    dom = DirectProduct(from)
    codom = DirectProduct(to)
    return FPGen(dom, codom)
end


# Function Tupling generators #
# from domain and codomain
function FTGen(dom :: AbstractProduct, codom :: AbstractProduct)
    from = size(dom)
    to = size(codom)
    n = ndims(codom)
    #funs = Tuple(ExtFun(dom, codom[i]) for i in 1 : n)
    tup = Tuple(nfuns(dom, codom[i]) for i in 1 : n)
    itr = product(Segment.(tup)...)
    f = FunTupling(from, to)
    return FTGen(itr, f)
end

# from two tuples
function FTGen(from :: NTuple{N, Int}, to :: NTuple{M, Int}) where {N, M}
    dom = DirectProduct(from)
    codom = DirectProduct(to)
    return FTGen(dom, codom)
end



# iteration utilities #
function itstep(ctr, gen :: BoolGen)
    value = ctr[1]
    state = ctr[2]
    fill_bits!(gen.f.m, value)
    return (gen.f, state)
end

function itstep(ctr, gen :: ARGen)
    value = ctr[1]
    state = ctr[2]
    fill_numbers!(gen.f.m, value, base = gen.to)
    return (gen.f, state)
end

function itstep(ctr, gen :: FPGen)
    value = ctr[1]
    state = ctr[2]
    mods = size(domain(gen.f))
    for (i, v) in enumerate(value)
        fi = proj(gen.f, i)
        fill_numbers!(fi.m, v, base = mods[i])
    end
    return (gen.f, state)
end

function itstep(ctr, gen :: FTGen)
    value = ctr[1]
    state = ctr[2]
    mods = size(domain(gen))
    for (i, v) in enumerate(value)
        fi = proj(gen.f, i)
        fill_numbers!(fi.m, v, base = mods[i])
    end
    return (gen.f, state)
end

itstep(:: Nothing, gen) = nothing

Base.iterate(gen :: BoolGen) = itstep(iterate(gen.itr), gen)
Base.iterate(gen :: BoolGen, state) = itstep(iterate(gen.itr, state), gen)
Base.iterate(gen :: ARGen) = itstep(iterate(gen.itr), gen)
Base.iterate(gen :: ARGen, state) = itstep(iterate(gen.itr, state), gen)
Base.iterate(gen :: FXGens) = itstep(iterate(gen.itr), gen)
Base.iterate(gen :: FXGens, state) = itstep(iterate(gen.itr, state), gen)

#=
itstep(n :: Nothing, gen :: FTGen) = nothing
itstep(n :: Nothing, gen :: FPGen) = nothing
=#


# other useful functions #
Base.length(gen :: DFGen) = prod(big.(length.(gen.itr.iterators)))
# number of functions A → B
nfuns(dom :: FinSet, codom :: FinSet) = length(codom)^(length(dom))
domain(gen :: DFGen) = domain(gen.f)
codomain(gen :: DFGen) = codomain(gen.f)


# get n'th element of iterator
function Base.getindex(gen :: DFGen, i :: Int)
    return nth(gen, i)
end