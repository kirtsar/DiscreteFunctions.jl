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
function of the type 
ℤ_k1 × … × ℤ_km → ℤ_l
represened internally as array of integers 
"""
struct ExtendedResidueFunction{T, N} <: BasicDiscreteFunction
    m :: Vector{Int}
    dom :: DirectProduct{T}
    rng :: Segment{Int}
    sizes :: NTuple{N, Int}
end

const ResFun = ResidueFunction
const ExtFun = ExtendedResidueFunction

# ResidueFunction from domain and codomain
function ResFun(dom :: Segment, codom :: Segment)
    m = zeros(Int, length(dom))
    return ResFun(m, dom, codom)
end
# constructing [0..k-1] -> [0..l-1]
# input : max_x, max_y
ResFun(k, l) = ResFun(Segment(k), Segment(l))

# from tuple of args
# input : (tuple) = (max_x, max_y)
ResFun(tup :: Tuple{T, S}) where {T, S <: Integer} = ResFun(tup[1], tup[2])

# constructiong {0, ..., k-1} -> {0, .., k-1}
ResFun(k) = ResFun(k, k)


# ExtFun from domain and codomain
function ExtFun(dom :: AbstractProduct, codom :: Segment)
    m = zeros(Int, length(dom))
    return ExtFun(m, dom, codom, size(dom))
end

# ExtFun from tuple (sizes) and max_y
function ExtFun(sizes :: NTuple, max_y :: Int)
    dom = DirectProduct(map(Segment, sizes)...)
    codom = Segment(max_y)
    return ExtFun(dom, codom)
end

(f :: ResFun)(x :: Integer) = f.m[x + 1]
Base.setindex!(f :: ResFun, value, key) = setindex!(f.m, value, key + 1)

function (f :: ExtFun)(x :: Union{NTuple, Vector})
    ind = itr2ind(x, f.sizes)
    return f.m[ind + 1]
end

function Base.setindex!(f :: ExtFun, v, k :: NTuple)
    ind = itr2ind(k, f.sizes)
    f.m[ind+1] = v
end
Base.setindex!(f :: ExtFun, v, k...) = setindex!(f, v, tuple(k...))
