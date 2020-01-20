function itr2bin(x)
    res = 0
    for v in x
        res += v
        res <<= 1
    end
    return res >> 1
end


function fill_bits!(v, x)
    for i in length(v) : -1 : 1
        v[i] = x & 1
        x >>= 1
    end
end


function fill_numbers!(v, x; base ::Int)
    for i in length(v) : -1 : 1
        v[i] = x % base
        x = div(x, base)
    end
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