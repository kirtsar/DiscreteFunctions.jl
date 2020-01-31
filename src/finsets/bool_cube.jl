"""
Finite set {0,1} × ... × {0,1}
"""
struct BooleanCube{S} <: AbstractProduct
    itr :: UnitRange{S}
    n :: Int
end
const BoolCube = BooleanCube
const BCube = BooleanCube

"""
construct a boolean cube with given number of dimensions
"""
BCube(n :: Int) = BCube(0:(2^n - 1), n)

#### Boolean vectors

struct BooleanVector
    k :: Int
    n :: Int
end
const BoolVec = BooleanVector
const BooleanVec = BooleanVector

value(v :: BoolVec) = v.k

function Base.getindex(v :: BoolVec, i :: Int)
    n = ndims(v)
    return (value(v) >> (n - i)) & 1 
end

# INTERFACE
iterator(bc :: BCube) = bc.itr
Base.ndims(bc :: BCube) = bc.n
Base.ndims(v :: BoolVec) = v.n
factors(bc :: BCube) = tuple(fill(0:1, ndims(bc))...)


# Iteration utilities
postprocess(:: Nothing, n) = nothing
postprocess(p, n) = (BoolVec(p[1], n), p[2])

function Base.iterate(bc :: BCube)
    p = iterate(bc.itr)
    return postprocess(p, ndims(bc))
end

function Base.iterate(bc :: BCube, state)
    p = iterate(bc.itr, state)
    return postprocess(p, ndims(bc))
end


# change representation from binary to BoolVec
function (bc :: BoolCube)(x :: NTuple)
    n = ndims(bc)
    res = 0
    for i in 1 : n
        res <<= 1
        res |= x[i]
    end
    return BoolVec(res, n)
end




# show utilities
Base.show(io :: IO, bc :: BooleanCube) = print(io, "[0, 1]^$(ndims(bc))")

function Base.show(io :: IO, v :: BoolVec)
    n = ndims(v) - 1
    s = bitstring(value(v))[end - n : end]
    print(io, "[", s, ']')
end
