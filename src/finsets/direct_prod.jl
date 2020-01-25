"""
direct product of two or more sets
"""
struct DirectProduct{T} <: AbstractProduct
    itr :: T
end
const DProd = DirectProduct

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


# INTERFACE implementation
iterator(dp :: DirectProduct) = dp.itr
factors(dp :: DirectProduct) = dp.itr.iterators
