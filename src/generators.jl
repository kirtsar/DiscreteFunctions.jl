abstract type DiscreteFunctionGenerator end

"""
Generates all boolean function of arity = n
"""
struct BoolGen{F, S} <: DiscreteFunctionGenerator
    itr :: UnitRange{Int}
    f :: BooleanFunction{F, S}
end


function BoolGen(arity)
    itr = 0 : (2^(2^arity) - 1)
    f = BooleanFunction(arity)
    return BoolGen(itr, f)
end


function Base.iterate(bg :: BoolGen) 
    v = iterate(bg.itr)
    value = v[1]
    state = v[2]
    fill_bits!(bg.f.m, value)
    return (bg.f, state)
end


function Base.iterate(bg :: BoolGen, state)
    v = iterate(bg.itr, state)
    if (v == nothing)
        return nothing
    else
        value = v[1]
        state = v[2]
        fill_bits!(bg.f.m, value)
        return (bg.f, state)
    end
end 





struct ResidueGen <: DiscreteFunctionGenerator
    itr :: UnitRange{Int}
    f :: ResidueFunction
    from :: Int
    to :: Int
end


function ResidueGen(from, to)
    itr = 0 : (to^from - 1)
    f = ResidueFunction(from, to)
    return ResidueGen(itr, f, from, to)
end


function Base.iterate(gen :: ResidueGen) 
    v = iterate(gen.itr)
    value = v[1]
    state = v[2]
    fill_numbers!(gen.f.m, value, base = gen.to)
    return (gen.f, state)
end


function Base.iterate(gen :: ResidueGen, state)
    v = iterate(gen.itr, state)
    if (v == nothing)
        return nothing
    else
        value = v[1]
        state = v[2]
        fill_numbers!(gen.f.m, value, base = gen.to)
        return (gen.f, state)
    end
end



function Base.length(gen :: DiscreteFunctionGenerator)
    return length(gen.itr)
end

#=
function test(t1, t2)
    gen = DF.ResidueGen(t1, t2)
    s1 = 0
    s2 = 0
    for f in gen
        s1 += f(0)
        s2 += f(1)
    end
    return (s1, s2)
end
=#






