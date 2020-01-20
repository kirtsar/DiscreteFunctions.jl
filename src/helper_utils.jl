function itr2bin(x)
    res = 0
    for v in x
        res += v
        res <<= 1
    end
    return res >> 1
end


function table(f :: AbstractDiscreteFunction)
    d = domain(f)
    res = [x => f(x) for x in d]
    return res
end


function tablegen(f :: AbstractDiscreteFunction)
    d = domain(f)
    res = (x => f(x) for x in d)
    return res
end