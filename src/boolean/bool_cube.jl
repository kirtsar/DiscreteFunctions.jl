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
factors(bc :: BCube) = tuple(fill(0:1, ndims(bc))...)

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