abstract type AbstractDiscreteFunction end

"""
generic type for discrete function Dom -> Rng
"""
struct DiscreteFunction{D <: AbstractFiniteSet, R <: AbstractFiniteSet} <: AbstractDiscreteFunction
    m :: Dict{D, R}
    dom :: D
    rng :: R
end


"""
function of the type {0, .., k-1} -> {0, ..., k-1} 
represened internally as array of integers 
"""
struct ResidueFunction{T <: Integer, S <: Integer} <: AbstractDiscreteFunction
    m :: Vector{T}
    dom :: Segment{S}
    rng :: Segment{S}
end


"""
Boolean functions of the type B^n -> B
"""
struct BooleanFunction{T} <: AbstractDiscreteFunction
    m :: Vector{T}
    dom :: BooleanCube{T}
    rng :: Segment{T}
end


"""
bijective function {1, ..., k} -> {1, ..., k}
"""
struct Perm{T <: Integer} <: AbstractDiscreteFunction
    m :: Vector{T}
    dom :: ShiftedSegment{Int}
    rng :: ShiftedSegment{Int}
end


"""
bijective function {0, .. k-1} -> {0, ..., k-1}
"""
struct OffsetPerm{T <: Integer} <: AbstractDiscreteFunction
    m :: Vector{T}
    dom :: Segment{Int}
    rng :: Segment{Int}
end



""" 
direct product of two or more discrete functions
"""
struct FunProduct{T, D, R} <: AbstractDiscreteFunction
    factors :: T
    dom :: D
    rng :: R
end




function Perm(vec)
    k = maximum(vec)
    dom = segment(1, k)
    return Perm(vec, dom, dom)
end