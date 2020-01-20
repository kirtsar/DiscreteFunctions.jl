#  setindex!(collection, value, key...)

function Base.setindex!(f :: DiscreteFunction, v, k)
    f.m[k] = v
end

function Base.setindex!(f :: ResidueFunction, v, k)
    f.m[k+1] = v
end

function Base.setindex!(f :: BooleanFunction, v, k)
    ind = itr2bin(k)
    f.m[ind + 1] = v
end

function Base.setindex!(f :: BooleanFunction, v, k)
    ind = itr2bin(k)
    f.m[ind + 1] = v
end


function Base.setindex!(ft :: FunProduct, v :: NTuple, k :: NTuple)
    fs = factors(ft)
    for (i, val) in enumerate(v)
        ind = itr2bin(k[i])
        fs[i][ind] = val
    end
end


function Base.setindex!(ft :: FunTupling, v :: NTuple, k)
    ind = itr2bin(k)
    fs = factors(ft)
    for (i, val) in enumerate(v)
        fs[i][ind] = val
    end
end


function Base.setindex!(ft :: CompositeFunction, v :: NTuple, k...)
    ft[tuple(k...)] = v
end
