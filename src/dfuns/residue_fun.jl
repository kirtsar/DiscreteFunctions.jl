"""
function of the type {0, .., k-1} -> {0, ..., l-1} 
represened internally as array of integers 
"""
struct ResidueFunction <: BasicFunction
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

