abstract type AbstractDiscreteFunction end
abstract type CompositeFunction <: AbstractDiscreteFunction end
abstract type BasicDiscreteFunction <: AbstractDiscreteFunction end

"""
generic type for discrete function Dom -> Rng
"""
struct DiscreteFunction{D <: AbstractFiniteSet, R <: AbstractFiniteSet, A, B} <: AbstractDiscreteFunction
    m :: Dict{A, B}
    dom :: D
    rng :: R
end


"""
function of the type {0, .., k-1} -> {0, ..., l-1} 
represened internally as array of integers 
"""
struct ResidueFunction <: BasicDiscreteFunction
    m :: Vector{Int}
    dom :: Segment{Int}
    rng :: Segment{Int}
end


"""
function of the type 
ℤ_k1 × … × ℤ_km → ℤ_l
represened internally as array of integers 
"""
struct ExtendedResidueFunction{T, N} <: BasicDiscreteFunction
    m :: Vector{Int}
    dom :: DirectProduct{T}
    rng :: Segment{Int}
    sizes :: NTuple{N, Int}
end


"""
Boolean functions of the type B^n -> B
"""
struct BooleanFunction{T, S} <: BasicDiscreteFunction
    m :: Vector{T}
    dom :: BooleanCube{S}
    rng :: Segment{Int}
end



"""
Boolean map of type B^n -> B^m
"""
struct BooleanMap{T} <: AbstractDiscreteFunction
    m :: Matrix{T}
    dom :: BooleanCube{Int}
    rng :: Segment{Int}
end



"""
bijective function {1, ..., k} -> {1, ..., k}
"""
struct Perm{T <: Integer} <: BasicDiscreteFunction
    m :: Vector{T}
    dom :: ShiftedSegment{Int}
    rng :: ShiftedSegment{Int}
end


"""
bijective function {0, .. k-1} -> {0, ..., k-1}
"""
struct OffsetPerm{T <: Integer} <: BasicDiscreteFunction
    m :: Vector{T}
    dom :: Segment{Int}
    rng :: Segment{Int}
end

""" 
direct product of two or more discrete functions

if we have:
    ``f_1 : D_1 → R_1``
    `` …``
    ``f_k : D_k → R_k``
then FunProduct((f1, …, fk)) is F
    F : D1 × … × Dk → R1 × … × Rk
"""
struct FunProduct{N, T, D, R} <: CompositeFunction
    factors :: NTuple{N, T}
    dom :: D
    rng :: R
end


""" 
tupling of two or more discrete functions
if we have
    f1 : D → R1
    f2 : D → R2
        …
    fk : D → Rk
then FunTupling((f1, …, fk)) is F
    F : D → R1 × … × Rk
"""
struct FunTupling{N, T, D, R} <: CompositeFunction
    factors :: NTuple{N, T}
    dom :: D
    rng :: R
end


const DFun = DiscreteFunction
const ResFun = ResidueFunction
const ExtFun = ExtendedResidueFunction
const BoolFun = BooleanFunction
const BoolMap = BooleanMap
const CompFun = CompositeFunction



##############################
# STANDARD CONSTRUCTORS ######
##############################

function DiscreteFunction(d :: Dict{A, B}) where {A, B}
    min_x = minimum(keys(d))
    max_x = maximum(keys(d))
    min_y = minimum(values(d))
    max_y = maximum(values(d))
    D = Segment(min_x, max_x)
    R = Segment(min_y, max_y)
    return DiscreteFunction(d, D, R)
end


# ResidueFunction from domain and codomain
function ResidueFunction(dom :: Segment, codom :: Segment)
    m = zeros(Int, length(dom))
    return ResidueFunction(m, dom, codom)
end


# constructing [0..max_x-1] -> [0..max_y-1]
# input : max_x, max_y
function ResidueFunction(max_x, max_y)
    dom = Segment(max_x)
    codom = Segment(max_y)
    return ResidueFunction(dom, codom)
end

# constructing [0..max_x-1] -> [0..max_y-1]
# input : (tuple) = (max_x, max_y)
function ResidueFunction(tup :: Tuple{T, S}) where {T, S <: Integer}
    return ResidueFunction(tup[1], tup[2])
end


# ResidueFunction from domain and codomain
function ExtendedResidueFunction(dom :: AbstractProduct, codom :: Segment)
    sizes = size(dom)
    m = zeros(Int, length(dom))
    return ExtendedResidueFunction(m, dom, codom, sizes)
end


# ResidueFunction from tuple (sizes) and max_y
function ExtendedResidueFunction(sizes :: NTuple, max_y :: Int)
    dom = DirectProduct(map(Segment, sizes)...)
    codom = Segment(max_y)
    return ExtendedResidueFunction(dom, codom)
end



function BooleanFunction(arity :: Int)
    dom = BooleanCube(Val(arity))
    rng = Segment(2)
    m = zeros(Int, 2^arity)
    return BooleanFunction(m, dom, rng)
end


function BooleanFunction(arity :: Val{N}) where N
    dom = BooleanCube(arity)
    rng = Segment(2)
    m = zeros(Int, 2^N)
    return BooleanFunction(m, dom, rng)
end


function BooleanFunction(v :: Union{NTuple, Vector})
    n = length(v)
    nn = Int(log2(n))
    arity = Val(nn)
    return BooleanFunction(v, arity)
end


function BooleanFunction(v :: Union{NTuple, Vector}, arity :: Val{N}) where N
    bf = BooleanFunction(arity)
    for (i, x) in enumerate(domain(bf))
        bf[x] = v[i]
    end
    return bf
end


function Perm(v)
    k = maximum(v)
    dom = Segment(1, k)
    return Perm(v, dom, dom)
end


function OffsetPerm(v)
    k = maximum(v)
    dom = Segment(k)
    return OffsetPerm(v, dom, dom)
end


function FunProduct(factors)
    dom = DirectProduct(map(domain, factors))
    rng = DirectProduct(map(codomain, factors))
    return FunProduct(factors, dom, rng)
end


function FunTupling(factors)
    dom = domain(first(factors))
    rng = DirectProduct(map(codomain, factors))
    return FunTupling(factors, dom, rng)
end


# creating functional product from two tuples
# of equal length!

function FunProduct(from :: NTuple{N, Int}, to :: NTuple{N, Int}) where N
    fromto = zip(from, to)
    funs = tuple(map(ResidueFunction, fromto)...)
    return FunProduct(funs)
end


# creating functional product from dom and codom

function FunProduct(dom :: AbstractProduct, codom :: AbstractProduct)
    fromto = zip(from, to)
    funs = tuple(map(ResidueFunction, fromto)...)
    return FunProduct(funs)
end

# creating functional tupling from two tuples
# not necessarily equal length !

function FunTupling(from :: NTuple{N, Int}, to :: NTuple{M, Int}) where N where M
    funs = tuple(map(x -> ExtendedResidueFunction(from, x), to)...)
    return FunTupling(funs)
end

FunProduct(factors...) = FunProduct(tuple(factors...))
FunTupling(factors...) = FunTupling(tuple(factors...))

# number of functions 
size(comp :: CompositeFunction) = length(fp.factors)