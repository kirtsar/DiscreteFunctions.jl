abstract type AbstactBoolean <: BasicDiscreteFunction end

"""
Boolean functions of the type B^n -> B
"""
struct BooleanFunction{T} <: AbstactBoolean
    m :: Vector{T}
end

"""
Boolean map of type B^n -> B^m
"""
struct BooleanMap{T} <: AbstactBoolean
    m :: Matrix{T}
end

const BoolFun = BooleanFunction
const BoolMap = BooleanMap

size(f :: AbstactBoolean) = size(f.m)
arity(f :: BoolFun) = Int(log2(size(f)[1]))
arity(f :: BoolMap) = Int(log2(size(f)[2]))
nfuns(f :: BoolFun) = 1
nfuns(f :: BoolMap) = size(f)[1]

domain(f :: AbstactBoolean) = BCube(arity(f))
codomain(f :: AbstactBoolean) = BCube(nfuns(f))

# standard constructor from domain (and range)
BoolFun(bc :: BCube) = BoolFun(zeros(Int, length(bc)))
BoolMap(dom :: BCube, rng :: BCube) = BoolMap(zeros(Int, (ndims(rng), length(dom))))

# construct from arities - number
BoolFun(arity :: Int) = BoolFun(BCube(arity))
BoolMap(m :: Int, n :: Int) = BoolMap(BCube(m), BCube(n))

# construct from values
BoolFun(tup :: NTuple) = BoolFun(collect(tup))

# apply to BoolVec
(f :: BoolFun)(v :: BoolVec) = BoolVec(f.m[value(v) + 1], 1)
(f :: BoolMap)(v :: BoolVec) = BoolVec(f.m[:, value(v) + 1])
# apply to Iterable
function (f :: AbstactBoolean)(it)
    x = BoolVec(it)
    return f(x)
end
# apply to bunch of numbers
(fs :: AbstactBoolean)(v...) = fs(tuple(v...))

setindex!(f :: BoolFun, v, k :: BoolVec) = (f.m[value(k) + 1] = v)
function setindex!(f :: BoolMap, v, k :: BoolVec)
    col = value(k) + 1
    for row in 1 : nfuns(f)
        f.m[row, col] = v[row]
    end
    return nothing
end
setindex!(f :: AbstactBoolean, v, k) = (f[BoolVec(k)] = v)
setindex!(f :: AbstactBoolean, v, k...) = (f[tuple(k...)] = v)

function direct(fs :: Union{NTuple{N, T}, Vector{T}}) where T <: BoolFun where N
    dom = domain(fs[1])
    dim_dom = ndims(dom)
    dim_rng = length(fs)
    fprod = BoolMap(dim_dom, dim_rng)
    for x in dom
        y = Tuple(f(x) for f in fs)
        fprod[x] = y
    end
    return fprod
end

mat(f :: AbstactBoolean) = f.m
proj(f :: BoolMap, i) = BoolFun(f.m[i, :])
getindex(f :: BoolMap, i) = proj(f, i)
length(f :: BoolMap) = nfuns(f)
iterate(f :: BoolMap) = (f[1], 2)
iterate(f :: BoolMap, i) = (i <= length(f)) ? (f[i], i+1) : nothing