"""
Finite set {0,1} × ... × {0,1}
"""
struct BooleanCube{S} <: AbstractProduct
    itr :: S
end
const BCube = BooleanCube


"""
construct a boolean cube with given number of dimensions
"""
BooleanCube(ndim :: Int) = BooleanCube(Val(ndim))

function BooleanCube(u :: Val{N}) where N
    itr = DirectProduct(ntuple(x -> Segment(2), u)...)
    return BooleanCube(itr)
end

# INTERFACE
iterator(bc :: BooleanCube) = bc.itr


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

factors(bc :: BooleanCube) = tuple(fill(0:1, length(bc))...)