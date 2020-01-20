function domain(m :: AbstractDiscreteFunction)
    return m.dom
end


function codomain(m :: AbstractDiscreteFunction)
    return m.rng
end

# TODO : not the same as codomain
# function is surjective f : dom -> rng
function rng(m :: AbstractDiscreteFunction)
    return codomain(m)
end

"""
return factors (f1, ..., fp) for composite function,
that is : functional product of functional tupling
"""
function factors(fp :: CompositeFunction)
    return fp.factors
end


function (df :: DiscreteFunction)(x)
    return f.m[x]
end


function (f :: ResidueFunction)(x :: Integer)
    return f.m[x + 1]
end


function (f :: BooleanFunction)(it :: Union{NTuple, Vector})
    x = itr2bin(it)
    return f.m[x + 1]
end


function (f :: BooleanFunction)(x...)
    return f(tuple(x...))
end


function (p :: Perm)(x)
    return p.m[x]
end


function (p :: OffsetPerm)(x)
    return p.m[x+1]
end


function (fp :: FunProduct{N, T, D, R})(v) where {N,T,D,R}
    funs = factors(fp)
    n = length(v)
    return NTuple{N}(funs[i](v[i]) for i in 1 : n)
end


function (ft :: FunTupling{N, T, D, R})(v) where {N,T,D,R}
    funs = factors(ft)
    n = length(funs)
    return NTuple{N}(funs[i](v) for i in 1 : n)
end


function (fp :: FunProduct)(v...)
    return fp(tuple(v...))
end


function (ft :: FunTupling)(v...)
    return fp(tuple(v...))
end


function proj(f :: CompositeFunction, i)
    return factors(f)[i]
end


