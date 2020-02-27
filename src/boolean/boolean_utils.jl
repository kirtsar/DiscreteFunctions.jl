"""
Generic Boolean
"""
struct BooleanGeneric{T, S} <: AbstactBoolean
    m :: T
    dom :: BCube{Int}
    rng :: Val{S}
end

domain(f :: BooleanGeneric) = f.dom
codomain(f :: BooleanGeneric{T, S}) where {T, S} = S

(f :: BooleanGeneric)(v :: BoolVec) = f.m[value(v) + 1]

function BooleanGeneric(bc :: BCube)
    m = zeros(Int, length(bc))
    rng = Val(Int)
    return BooleanGeneric(m, bc, rng)
end

setindex!(f :: BooleanGeneric, v, k :: BoolVec) = (f.m[value(k) + 1] = v)

# given bool func, find its Walsh-Hadamard spectrum
function spectrum(f :: BoolFun)
    g = BooleanGeneric(domain(f))
    for y in domain(g)
        res = 0
        for x in domain(f)
            res += (-1)^(dot(x, y) + value(f(x)))
        end
        g[y] = res
    end
    return g
end









