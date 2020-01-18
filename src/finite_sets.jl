#########################################
# different types of domains and ranges #
#########################################

abstract type AbstractFiniteSet end
abstract type AbstractSegment <: AbstractFiniteSet end
abstract type AbstractProduct <: AbstractFiniteSet end


"""
Finite set {0, .., k-1}
"""
struct Segment{T} <: AbstractSegment
    itr :: UnitRange{T}
end


"""
Finite set {c, .., c + k-1}
"""
struct ShiftedSegment{T} <: AbstractSegment
    itr :: UnitRange{T}
    shift :: Int
end


"""
Returns Segment [0..k-1]
"""
function segment(k :: Int)
    itr = 0 : (k-1)
    return Segment(itr)
end


"""
Returns Segment [start..start + k-1]
"""
function segment(start, k)
    itr = start : (start + (k-1))
    return ShiftedSegment(itr, start)
end


"""
direct product of two or more sets
"""
struct DirectProduct{T, S} <: AbstractProduct
    itr :: T
    factors :: S
    len :: Int
end


function DirectProduct(x...)
    itr = product(x...)
    factors = tuple(x...)
    len = length(x)
    return DirectProduct(itr, factors, len)
end


"""
Finite set {0,1} × ... × {0,1}
"""
struct BooleanCube{S} <: AbstractProduct
    itr :: S
    len :: Int
end


function BooleanCube(len :: Int)
    itr = DirectProduct(fill(segment(2), len)...)
    return BooleanCube(itr, len)
end


# iteration utilities

function Base.first(s :: AbstractSegment)
    return first(s.itr)
end


function Base.last(s :: AbstractSegment)
    return last(s.itr)
end


function Base.iterate(s :: AbstractFiniteSet) 
    return iterate(s.itr)
end


function Base.iterate(s :: AbstractFiniteSet, state)
    return iterate(s.itr, state)
end


function factors(dp :: DirectProduct)
    return dp.factors
end

function len(x :: AbstractProduct)
    return x.len
end
