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
end


"""
Returns Segment [0..k-1]
"""
function segment(k :: Int)
    itr = 0 : (k-1)
    return Segment(itr)
end


"""
Returns Segment [start..finish]
"""
function segment(start, finish)
    itr = start : finish
    return ShiftedSegment(itr)
end


"""
direct product of two or more sets
"""
struct DirectProduct{T} <: AbstractProduct
    itr :: T
end


"""
return direct product of finite sets x...
"""
function DirectProduct(x...)
    itr = product(x...)
    return DirectProduct(itr)
end


"""
Finite set {0,1} × ... × {0,1}
"""
struct BooleanCube{S} <: AbstractProduct
    itr :: S
end

"""
construct a boolean cube with given number of dimensions
"""
function BooleanCube(ndim :: Int)
    itr = DirectProduct(fill(segment(2), ndim)...)
    return BooleanCube(itr)
end

#######################
# iteration utilities #
#######################

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


# special iteration protocol for direct product
# because we want the boolean cube to be like:
# (0, 0, ..., 0), (0, 0, ..., 1)
# and not (0, 0, ..., 0), (1, 0, ..., 0)
# (lexicografic order matters here)


function Base.iterate(dp :: DirectProduct)
    p = iterate(dp.itr)
    res = _try_reverse(p)
    return res
end


function Base.iterate(dp :: DirectProduct, state)
    p = iterate(dp.itr, state)
    res = _try_reverse(p)
    return res
end


function _try_reverse(p :: Nothing)
    return nothing
end


function _try_reverse(p)
    return (reverse(first(p)), last(p)) 
end


function factors(dp :: DirectProduct)
    return dp.itr.iterators
end


function Base.length(s :: AbstractFiniteSet)
    return length(s.itr)
end


function Base.ndims(s :: AbstractFiniteSet)
    return ndims(s.itr)
end

