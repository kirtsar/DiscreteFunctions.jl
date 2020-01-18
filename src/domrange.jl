function dom(m :: AbstractDiscreteFunction)
    return m.dom
end

function codomain(m :: AbstractDiscreteFunction)
    return m.rng
end

function rng(m :: AbstractDiscreteFunction)
    return codomain(m)
end


function (df :: DiscreteFunction)(x)
    return f.m[x]
end


function (f :: ResidueFunction)(x)
    return f.m[x + 1]
end



#=
function dom(x) end


function rng(x) end


function dom(rf :: ResidueFunction)
    return FinSet(rf.dom)
end


function rng(rf :: ResidueFunction)
    return FinSet(rf.dom)
end


function dom(bf :: BooleanFunction)
    len = bf.dom
    dtype = Tuple([FinSet(2) for i in 1 : len])
    return DirectProduct(dtype, len)
end


function rng(bf :: BooleanFunction)
    return FinSet(2)
end


function dom(p :: Perm)
    return ShiftedFinSet(p.dom)
end


function rng(p :: Perm)
    return dom(p)
end


function dom(op :: OffsetPerm)
    return FinSet(op.dom)
end


function rng(op :: OffsetPerm)
    return dom(p)
end


function dom(dp :: DirectProduct)
    res = map(dom, dp.factors)
    return DirectProduct(res)
end


function rng(dp :: DirectProduct)
    res = map(dom, dp.factors)
    return DirectProduct(res)
end
=#