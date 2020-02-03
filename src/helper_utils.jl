function itr2bin(x)
    res = 0
    for v in x
        res += v
        res <<= 1
    end
    return res >> 1
end


function itr2ind(x, sizes)
    n = length(sizes)
    res = 0
    _mul = 1
    for i in n : -1 : 1
        res += x[i] * _mul
        _mul *= sizes[i]
    end
    return res
end

# fill array v with bits of number x 
function fill_bits!(v, x)
    for i in length(v) : -1 : 1
        v[i] = x & 1
        x >>= 1
    end
end

# fill array v with digits of number x in base-system
function fill_numbers!(v, x; base :: Int)
    for i in length(v) : -1 : 1
        v[i] = x % base
        x = div(x, base)
    end
end

# set bits with numbers vs[1],
# ..., vs[k] to 1
# return 2^(vs[1] - 1) + ... + 2^(vs[k] - 1)
function set_bits(vs)
    res = 0
    for num in vs
        res += 2^(num - 1)
    end
    return res
end