"""
bijective function {1, ..., k} -> {1, ..., k}
"""
struct Perm{T <: Integer} <: BasicDiscreteFunction
    m :: Vector{T}
    dom :: ShiftedSegment{Int}
    rng :: ShiftedSegment{Int}
end


"""
bijective function {0, .. k-1} -> {0, ..., k-1}
"""
struct OffsetPerm{T <: Integer} <: BasicDiscreteFunction
    m :: Vector{T}
    dom :: Segment{Int}
    rng :: Segment{Int}
end


function Perm(v)
    k = maximum(v)
    dom = Segment(1, k)
    return Perm(v, dom, dom)
end


function OffsetPerm(v)
    k = maximum(v)
    dom = Segment(k)
    return OffsetPerm(v, dom, dom)
end