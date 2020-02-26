abstract type AbstactBoolean <: BasicDiscreteFunction end

"""
Boolean functions of the type B^n -> B
"""
struct BooleanFunction{T} <: AbstactBoolean
    m :: T
    dom :: BCube{Int}
    rng :: BCube{Int}
end

"""
Boolean map of type B^n -> B^m
"""
struct BooleanMap{T} <: AbstactBoolean
    m :: T
    dom :: BCube{Int}
    rng :: BCube{Int}
end

const BoolFun = BooleanFunction
const BoolMap = BooleanMap

domain(bf :: AbstactBoolean) = bf.dom
codomain(bf :: AbstactBoolean) = bf.rng

# standard constructor from domain (and range)
BoolFun(bc :: BCube) = BoolFun(zeros(Int, length(bc)), bc, BCube(1))

function BoolMap(dom :: BCube, rng :: BCube)
    bv = BoolVec(0, ndims(rng))
    m = [bv for i in 1 : length(dom)]
    return BoolMap(m, dom, rng)
end

# construct from arities - number
BoolFun(arity :: Int) = BoolFun(BCube(arity))
BoolMap(m :: Int, n :: Int) = BoolMap(BCube(m), BCube(n))

# construct from values
function BoolFun(vals :: Union{NTuple, Vector})
    arity = Int(log2(length(vals)))
    dom = BCube(arity)
    cod = BCube(1)
    return BoolFun(vals, dom, cod)
end

# apply to BoolVec
(f :: AbstactBoolean)(v :: BoolVec) = f.m[value(v) + 1]
# apply to Iterable
function (f :: AbstactBoolean)(it :: Union{NTuple, Vector})
    x = domain(f)(it)
    return f(x)
end
# apply to bunch of numbers
(fs :: AbstactBoolean)(v...) = fs(tuple(v...))

setindex!(f :: AbstactBoolean, v, k :: BoolVec) = (f.m[value(k) + 1] = domain(f)(v))
setindex!(f :: AbstactBoolean, v, k) = (f[domain(f)(k)] = v)
setindex!(f :: AbstactBoolean, v, k...) = (f[tuple(k...)] = v)

function direct(fs :: Union{NTuple{N, T}, Vector{T}}) where T <: BoolFun where N
    #dim_dom = map(x -> ndims(domain(x)), +, fs)
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

mat_repr(f :: BoolFun) = f.m
function mat_repr(fs :: BoolMap)
    rows = length(domain(fs))
    cols = ndims(codomain(fs))
    res = zeros(Int, rows, cols)
    row = zeros(Int, cols)
    for (i, x) in enumerate(domain(fs))
        fx = fs(x)
        fill_bits!(row, value(fx))
        res[i, :] .= row
    end
    return res
end

