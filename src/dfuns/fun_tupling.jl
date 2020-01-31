""" 
tupling of two or more discrete functions
if we have
    f1 : D → R1
    f2 : D → R2
        …
    fk : D → Rk
then FunTupling((f1, …, fk)) is F
    F : D → R1 × … × Rk
"""
struct FunTupling{N, T, D, R} <: CompositeFunction
    factors :: NTuple{N, T}
    dom :: D
    rng :: R
end

const FTuple = FunTupling


function FTuple(factors)
    dom = domain(first(factors))
    rng = DirectProduct(map(codomain, factors))
    return FTuple(factors, dom, rng)
end


# creating functional tupling from two tuples
# not necessarily equal length !

function FTuple(from :: NTuple{N, Int}, to :: NTuple{M, Int}) where N where M
    funs = tuple(map(x -> ExtendedResidueFunction(from, x), to)...)
    return FTuple(funs)
end


# creating functional product from dom and codom

function FTuple(dom :: AbstractProduct, codom :: AbstractProduct)
    #fromto = zip(from, to)
    #funs = tuple(map(ResidueFunction, fromto)...)
    #return FProd(funs)
    from = size(dom)
    to = size(codom)
    return FTuple(from, to)
end


function (ft :: FTuple{N, T, D, R})(v) where {N,T,D,R}
    funs = factors(ft)
    n = length(funs)
    return NTuple{N}(funs[i](v) for i in 1 : n)
end

function Base.setindex!(ft :: FTuple, v :: NTuple, k)
    fs = factors(ft)
    for (i, val) in enumerate(v)
        fs[i][k] = val
    end
end

(fs :: FTuple)(v...) = fs(tuple(v...))

FTuple(factors...) = FTuple(tuple(factors...))
