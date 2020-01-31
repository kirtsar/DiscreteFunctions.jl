"""
Boolean functions of the type B^n -> B
"""
struct BooleanFunction{T} <: BasicDiscreteFunction
    m :: T
    dom :: BCube{Int}
    rng :: BCube{Int}
end

"""
Boolean map of type B^n -> B^m
"""
struct BooleanMap{T} <: AbstractDiscreteFunction
    m :: Matrix{T}
    dom :: BCube{Int}
    rng :: BCube{Int}
end

const BoolFun = BooleanFunction
const BoolMap = BooleanMap


domain(bf :: BoolFun) = bf.dom
codomain(bf :: BoolFun) = bf.rng

# standard constructor from domain
function BoolFun(bc :: BCube)
    m = zeros(Int, length(bc))
    rng = BCube(1)
    return BoolFun(m, bc, rng)
end

# construct from arity - number
function BoolFun(arity :: Int)
    dom = BooleanCube(arity)
    return BoolFun(dom)
end

# construct from values
function BoolFun(vals :: Union{NTuple, Vector})
    arity = Int(log2(length(vals)))
    dom = BCube(arity)
    cod = BCube(1)
    return BoolFun(vals, dom, cod)
end

# application - to BoolVec
(f :: BoolFun)(v :: BoolVec) = f.m[value(v) + 1]
# application - to Iterable
function (f :: BoolFun)(it :: Union{NTuple, Vector})
    x = domain(f)(it)
    return f(x)
end
# application - to bunch of numbers
(fs :: BoolFun)(v...) = fs(tuple(v...))

Base.setindex!(f :: BoolFun, v, k :: BoolVec) = (f.m[value(k) + 1] = v)
Base.setindex!(f :: BoolFun, v, k) = (f[domain(f)(k)] = v)
Base.setindex!(f :: BoolFun, v, k...) = (f[tuple(k...)] = v)

