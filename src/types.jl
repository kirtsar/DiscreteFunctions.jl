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
if we have
    f1 : D1 → R1
    f2 : D2 → R2
        …
    fk : Dk → Rk
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



##############################
# STANDARD CONSTRUCTORS ######
##############################

function DiscreteFunction(d :: Dict{A, B}) where {A, B}
    min_x = minimum(keys(d))
    max_x = maximum(keys(d))
    min_y = minimum(values(d))
    max_y = maximum(values(d))
    D = segment(min_x, max_x)
    R = segment(min_y, max_y)
    return DiscreteFunction(d, D, R)
end


function ResidueFunction(max_x :: T, max_y :: S) where {T, S <: Integer}
    dom = segment(max_x)
    rng = segment(max_y)
    m = zeros(S, len(dom))
    return ResidueFunction(m, dom, rng)
end


function BooleanFunction(arity :: Int)
    dom = BooleanCube(arity)
    rng = segment(2)
    m = zeros(Int, 2^arity)
    return BooleanFunction(m, dom, rng)
end


function Perm(v)
    k = maximum(v)
    dom = segment(1, k)
    return Perm(v, dom, dom)
end


function OffsetPerm(v)
    k = maximum(v)
    dom = segment(k)
    return OffsetPerm(v, dom, dom)
end


function FunProduct(factors)
    dom = DirectProduct(map(domain, factors)...)
    rng = DirectProduct(map(codomain, factors)...)
    return FunProduct(factors, dom, rng)
end


function FunTupling(factors)
    dom = domain(first(factors))
    rng = DirectProduct(map(codomain, factors)...)
    return FunTupling(factors, dom, rng)
end


function (f :: Union{FunProduct, FunTupling})(factors...)
    return f(tuple(factors...))
end