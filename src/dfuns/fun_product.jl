""" 
direct product of two or more discrete functions

if we have:
    ``f_1 : D_1 → R_1``
    `` …``
    ``f_k : D_k → R_k``
then FunProduct((f1, …, fk)) is F
    F : D1 × … × Dk → R1 × … × Rk
"""
struct FunProduct{N, T, D, R} <: CompositeFunction
    factors :: NTuple{N, T}
    dom :: D
    rng :: R
end

const FProd = FunProduct

domain(fp :: FProd) = fp.dom
codomain(fp :: FProd) = fp.rng
factors(fp :: FProd) = fp.factors


# creating functional product from dom and codom
function FProd(dom :: AbstractProduct, codom :: AbstractProduct)
    fs = Tuple(ResFun(dom[i], codom[i]) for i in 1 : ndims(dom))
    return FProd(fs, dom, codom)
end


# creating functional product from two tuples
# of equal length!

function FProd(from :: NTuple{N, Int}, to :: NTuple{N, Int}) where N
    fromto = zip(from, to)
    funs = tuple(map(ResidueFunction, fromto)...)
    return FProd(funs)
end



function FProd(factors)
    dom = DirectProduct(map(domain, factors))
    rng = DirectProduct(map(codomain, factors))
    return FProd(factors, dom, rng)
end


FProd(factors...) = FProd(tuple(factors...))

function (fp :: FProd{N, T, D, R})(v) where {N,T,D,R}
    funs = factors(fp)
    n = length(v)
    return NTuple{N}(funs[i](v[i]) for i in 1 : n)
end

function Base.setindex!(fp :: FProd, v :: NTuple, k :: NTuple)
    fs = factors(fp)
    for i in 1 : size(fp)
        fs[i][k[i]] = v[i]
    end
end
(fs :: FProd)(v...) = fs(tuple(v...))