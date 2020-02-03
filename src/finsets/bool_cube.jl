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

BoolVec(vs) = BoolVec(itr2bin(vs), length(vs))

value(v :: BoolVec) = v.k

# v1 <= v2 in lexicographic order?
Base.isless(v1 :: BoolVec, v2 :: BoolVec) = (value(v1) & value(v2) == value(v1))


function Base.getindex(v :: BoolVec, i :: Int)
    n = ndims(v)
    return (value(v) >> (n - i)) & 1 
end

# INTERFACE
iterator(bc :: BCube) = bc.itr
Base.ndims(bc :: BCube) = bc.n
Base.ndims(v :: BoolVec) = v.n
Base.length(v :: BoolVec) = ndims(v)
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

Base.iterate(v :: BoolVec) = (v[1], 2)
Base.iterate(v :: BoolVec, i :: Int) = i > ndims(v) ? nothing : (v[i], i+1)


# change representation from binary to BoolVec
(bc :: BoolCube)(x :: NTuple) = BoolVec(x)

dot(v1 :: BoolVec, v2 :: BoolVec) = sum(collect(v1) .* collect(v2)) % 2



# show utilities
Base.show(io :: IO, bc :: BooleanCube) = print(io, "[0, 1]^$(ndims(bc))")

function Base.show(io :: IO, v :: BoolVec)
    n = ndims(v) - 1
    s = bitstring(value(v))[end - n : end]
    print(io, "[", s, ']')
end
