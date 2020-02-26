"""
Generic Boolean
"""
struct BooleanDiscrete{T, S} <: AbstactBoolean
    m :: T
    dom :: BCube{Int}
    rng :: S
end


function BooleanDiscrete(bc :: BCube)
    m = zeros(Int, length(bc))
    rng = Val(Int)
    return BooleanDiscrete(m, bc, rng)
end


# given bool func, find its Walsh-Hadamard spectrum
function spectrum(f :: BoolFun)
    g = BooleanDiscrete(domain(f))
    for y in domain(g)
        res = 0
        for x in domain(f)
            res += (-1)^(dot(x, y) + f(x))
        end
        g[y] = res
    end
    return g
end









