"""
Boolean functions of the type B^n -> B
"""
struct BooleanFunction{T, S} <: BasicDiscreteFunction
    m :: Vector{T}
    dom :: BooleanCube{S}
    rng :: Segment{Int}
end



"""
Boolean map of type B^n -> B^m
"""
struct BooleanMap{T} <: AbstractDiscreteFunction
    m :: Matrix{T}
    dom :: BooleanCube{Int}
    rng :: Segment{Int}
end

const BoolFun = BooleanFunction
const BoolMap = BooleanMap

