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

# INTERFACE
iterator(bc :: BCube) = bc
ndims(bc :: BCube) = bc.n
length(bc :: BCube) = 2^ndims(bc)
factors(bc :: BCube) = tuple(fill(BCube(1), ndims(bc))...)

# Iteration utilities
postprocess(:: Nothing, n) = nothing
postprocess(p, n) = (BoolVec(p[1], n), p[2])

function iterate(bc :: BCube)
    p = iterate(bc.itr)
    return postprocess(p, ndims(bc))
end

function iterate(bc :: BCube, state)
    p = iterate(bc.itr, state)
    return postprocess(p, ndims(bc))
end

# direct product of two bool cubes
direct(bc1 :: BCube, bc2 :: BCube) = BCube(ndims(bc1) + ndims(bc2))

# show utilities
Base.show(io :: IO, bc :: BCube) = print(io, "{0,1}^$(ndims(bc))")





















#### Boolean vectors

struct BooleanVector
    k :: Int
    n :: Int
end

const BoolVec = BooleanVector
const BooleanVec = BooleanVector

BoolVec(vs :: Union{NTuple, Vector}) = BoolVec(itr2bin(vs), length(vs))
BoolVec(v :: BoolVec) = v
value(v :: BoolVec) = v.k
value(x) = x   # fallback

function getindex(v :: BoolVec, i :: Int)
    n = ndims(v)
    return (value(v) >> (n - i)) & 1 
end

ndims(v :: BoolVec) = v.n
length(v :: BoolVec) = ndims(v)
iterate(v :: BoolVec) = (v[1], 2)
iterate(v :: BoolVec, i :: Int) = i > ndims(v) ? nothing : (v[i], i+1)

dot(v1 :: BoolVec, v2 :: BoolVec) = sum(collect(v1) .* collect(v2)) % 2
# v1 <= v2 in lexicographic order?
isless(v1 :: BoolVec, v2 :: BoolVec) = (value(v1) & value(v2) == value(v1))

function Base.show(io :: IO, v :: BoolVec)
    n = ndims(v) - 1
    s = bitstring(value(v))[end - n : end]
    print(io, "[", s, ']')
end

# change representation to BoolVec
# (bc :: BCube)(x :: Union{NTuple, Array}) = BoolVec(x)
# (bc :: BCube)(x :: Int) = x