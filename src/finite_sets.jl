#########################################
# different types of domains and ranges #
#########################################

abstract type AbstractFiniteSet end
const FinSet = AbstractFiniteSet

abstract type AbstractSegment <: FinSet end
abstract type AbstractProduct <: FinSet end


##############################
####### T Y P E S ############
##############################

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
direct product of two or more sets
"""
struct DirectProduct{T} <: AbstractProduct
    itr :: T
end

"""
Finite set {0,1} × ... × {0,1}
"""
struct BooleanCube{S} <: AbstractProduct
    itr :: S
end


const BCube = BooleanCube
const DProd = DirectProduct

##############################
####### initializers #########
##############################


# Segment initializers

"""
Construct a Segment [0..k-1]
"""
Segment(k :: Int) = Segment(0 : (k-1))

"""
Construct a Segment [start..finish]
"""
Segment(start, finish) = ShiftedSegment(start : finish)


# Direct product INITIALIZERS

"""
return direct product of finite sets xs
"""
DirectProduct(xs...) = DirectProduct(product(xs...))

# from vector/tuple of finite sets
function DirectProduct(v :: Union{Vector{T}, NTuple{N, T}}) where T <: FinSet where N
    return DirectProduct(v...)
end

# from vector/tuple of Integers
function DirectProduct(v :: Union{Vector{T}, NTuple{N, T}}) where T <: Integer where N
    dom = map(Segment, v)
    return DirectProduct(dom)
end

# Boolean cube INITIALIZERS

"""
construct a boolean cube with given number of dimensions
"""
BooleanCube(ndim :: Int) = BooleanCube(Val(ndim))

function BooleanCube(u :: Val{N}) where N
    itr = DirectProduct(ntuple(x -> Segment(2), u)...)
    return BooleanCube(itr)
end

#######################
# iteration utilities #
#######################

Base.first(s :: AbstractSegment) = first(s.itr)
Base.last(s :: AbstractSegment) = last(s.itr)
Base.iterate(s :: FinSet) = iterate(s.itr)
Base.iterate(s :: FinSet, state) = iterate(s.itr, state)

# special iteration protocol for BooleanCube
# because we want the boolean cube to be like:
# (0, 0, ..., 0), (0, 0, ..., 1)
# and not (0, 0, ..., 0), (1, 0, ..., 0)
# (lexicografic order matters here)

function Base.iterate(bc :: BooleanCube)
    p = iterate(bc.itr)
    res = _try_reverse(p)
    return res
end

function Base.iterate(bc :: BooleanCube, state)
    p = iterate(bc.itr, state)
    res = _try_reverse(p)
    return res
end

_try_reverse(p :: Nothing) = nothing
_try_reverse(p) = (reverse(first(p)), last(p)) 

Base.length(s :: FinSet) = length(s.itr)
Base.ndims(s :: FinSet) = ndims(s.itr)
Base.size(s :: FinSet) = size(s.itr)

proj(dp :: DirectProduct, i) = dp.itr.iterators[i]
Base.getindex(dp :: DirectProduct, i :: Int) = proj(dp, i)
factors(dp :: DirectProduct) = dp.itr.iterators