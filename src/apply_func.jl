domain(m :: AbstractDiscreteFunction) = m.dom
codomain(m :: AbstractDiscreteFunction) = m.rng
# TODO : not the same as codomain
# function is surjective f : dom -> rng
rng(m :: AbstractDiscreteFunction) = codomain(m)

"""
return factors (f1, ..., fp) for composite function,
"""
factors(fp :: CompositeFunction) = fp.factors


# apply different discrete function
(df :: DiscreteFunction)(x) = f.m[x]
(f :: ResidueFunction)(x :: Integer) = f.m[x + 1]

function (f :: ExtendedResidueFunction)(x :: Union{NTuple, Vector})
    ind = itr2ind(x, f.sizes)
    return f.m[ind + 1]
end

function (f :: BooleanFunction)(it :: Union{NTuple, Vector})
    x = itr2bin(it)
    return f.m[x + 1]
end

(p :: Perm)(x) = p.m[x]
(p :: OffsetPerm)(x) = p.m[x+1]


function (fp :: FProd{N, T, D, R})(v) where {N,T,D,R}
    funs = factors(fp)
    n = length(v)
    return NTuple{N}(funs[i](v[i]) for i in 1 : n)
end


function (ft :: FTuple{N, T, D, R})(v) where {N,T,D,R}
    funs = factors(ft)
    n = length(funs)
    return NTuple{N}(funs[i](v) for i in 1 : n)
end


# short concise syntax f(x1, .., xn)
(fs :: Union{FProd, FTuple, BooleanFunction})(v...) = fs(tuple(v...))

proj(f :: CompositeFunction, i) = factors(f)[i]
Base.getindex(f :: CompositeFunction, i) = proj(f, i)


#  setindex!(collection, value, key...)
Base.setindex!(f :: DiscreteFunction, value, key) = setindex!(f.m, value, key)
Base.setindex!(f :: ResidueFunction, value, key) = setindex!(f.m, value, key + 1)

function Base.setindex!(f :: ExtendedResidueFunction, v, k :: NTuple)
    ind = itr2ind(k, f.sizes)
    f.m[ind+1] = v
end

function Base.setindex!(f :: BooleanFunction, v, k)
    ind = itr2bin(k)
    f.m[ind + 1] = v
end

function Base.setindex!(fp :: FProd, v :: NTuple, k :: NTuple)
    fs = factors(fp)
    for i in 1 : size(fp)
        fs[i][k[i]] = v[i]
    end
end

function Base.setindex!(ft :: FTuple, v :: NTuple, k)
    fs = factors(ft)
    for (i, val) in enumerate(v)
        fs[i][k] = val
    end
end

Base.setindex!(f :: ExtendedResidueFunction, v, k...) = setindex!(f, v, tuple(k...))
Base.setindex!(f :: BooleanFunction, v, k...) = setindex!(f, v, tuple(k...))
Base.setindex!(ft :: CompositeFunction, v :: NTuple, k...) = ft[tuple(k...)] = v