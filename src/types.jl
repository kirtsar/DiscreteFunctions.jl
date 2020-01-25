abstract type AbstractDiscreteFunction end
const ADFun = AbstractDiscreteFunction
abstract type CompositeFunction <: ADFun end
abstract type BasicFunction <: ADFun end


# INTERFACES

# iterator for domain
domain(m :: ADFun) = error("not implemented")
# iterator for codomain
codomain(m :: ADFun) = error("not implemented")
# basic constructor from domain and codomain
(adf :: ADFun)(dom :: FinSet, cod :: FinSet) = error("not implemented")

"""
return factors (f1, ..., fp) for composite function,
"""
factors(fp :: CompositeFunction) = error("not implemented")


rng(m :: AbstractDiscreteFunction) = codomain(m)



# number of functions 
size(comp :: CompositeFunction) = length(comp.factors)















"""
bijective function {1, ..., k} -> {1, ..., k}
"""
struct Perm{T <: Integer} <: BasicDiscreteFunction
    m :: Vector{T}
    dom :: ShiftedSegment{Int}
    rng :: ShiftedSegment{Int}
end


"""
bijective function {0, .. k-1} -> {0, ..., k-1}
"""
struct OffsetPerm{T <: Integer} <: BasicDiscreteFunction
    m :: Vector{T}
    dom :: Segment{Int}
    rng :: Segment{Int}
end

""" 
direct product of two or more discrete functions

if we have:
    ``f_1 : D_1 → R_1``
    `` …``
    ``f_k : D_k → R_k``
then FunProduct((f1, …, fk)) is F
    F : D1 × … × Dk → R1 × … × Rk
"""
struct FunProduct{N, T, D, R} <: CompositeFunction
    factors :: NTuple{N, T}
    dom :: D
    rng :: R
end


""" 
tupling of two or more discrete functions
if we have
    f1 : D → R1
    f2 : D → R2
        …
    fk : D → Rk
then FunTupling((f1, …, fk)) is F
    F : D → R1 × … × Rk
"""
struct FunTupling{N, T, D, R} <: CompositeFunction
    factors :: NTuple{N, T}
    dom :: D
    rng :: R
end



const CompFun = CompositeFunction
const FProd = FunProduct
const FTuple = FunTupling



##############################
# STANDARD CONSTRUCTORS ######
##############################

function DiscreteFunction(d :: Dict{A, B}) where {A, B}
    min_x = minimum(keys(d))
    max_x = maximum(keys(d))
    min_y = minimum(values(d))
    max_y = maximum(values(d))
    D = Segment(min_x, max_x)
    R = Segment(min_y, max_y)
    return DiscreteFunction(d, D, R)
end


# ResidueFunction from domain and codomain
ResFun(dom :: Segment, codom :: Segment) = ResFun(zeros(Int, length(dom)), dom, codom)

# constructing [0..max_x-1] -> [0..max_y-1]
# input : max_x, max_y
ResFun(max_x, max_y) = ResFun(Segment(max_x), Segment(max_y))

# constructing [0..max_x-1] -> [0..max_y-1]
# input : (tuple) = (max_x, max_y)
ResFun(tup :: Tuple{T, S}) where {T, S <: Integer} = ResFun(tup[1], tup[2])



# ResidueFunction from domain and codomain
ExtFun(dom :: AbstractProduct, codom :: Segment) = ExtFun(zeros(Int, length(dom)), dom, codom, size(dom))

# ResidueFunction from tuple (sizes) and max_y
function ExtFun(sizes :: NTuple, max_y :: Int)
    dom = DirectProduct(map(Segment, sizes)...)
    codom = Segment(max_y)
    return ExtFun(dom, codom)
end



function BoolFun(arity :: Int)
    dom = BooleanCube(Val(arity))
    rng = Segment(2)
    m = zeros(Int, 2^arity)
    return BoolFun(m, dom, rng)
end


function BoolFun(arity :: Val{N}) where N
    dom = BooleanCube(arity)
    rng = Segment(2)
    m = zeros(Int, 2^N)
    return BoolFun(m, dom, rng)
end

function BoolFun(v :: Union{NTuple, Vector})
    arity = Val(Int(log2(length(v))))
    return BoolFun(v, arity)
end

function BoolFun(v :: Union{NTuple, Vector}, arity :: Val{N}) where N
    bf = BoolFun(arity)
    for (i, x) in enumerate(domain(bf))
        bf[x] = v[i]
    end
    return bf
end


function Perm(v)
    k = maximum(v)
    dom = Segment(1, k)
    return Perm(v, dom, dom)
end


function OffsetPerm(v)
    k = maximum(v)
    dom = Segment(k)
    return OffsetPerm(v, dom, dom)
end


function FProd(factors)
    dom = DirectProduct(map(domain, factors))
    rng = DirectProduct(map(codomain, factors))
    return FProd(factors, dom, rng)
end


function FTuple(factors)
    dom = domain(first(factors))
    rng = DirectProduct(map(codomain, factors))
    return FTuple(factors, dom, rng)
end


# creating functional product from two tuples
# of equal length!

function FProd(from :: NTuple{N, Int}, to :: NTuple{N, Int}) where N
    fromto = zip(from, to)
    funs = tuple(map(ResidueFunction, fromto)...)
    return FProd(funs)
end


# creating functional product from dom and codom

function FProd(dom :: AbstractProduct, codom :: AbstractProduct)
    #fromto = zip(from, to)
    #funs = tuple(map(ResidueFunction, fromto)...)
    #return FProd(funs)
    from = size(dom)
    to = size(codom)
    return FProd(from, to)
end

# creating functional tupling from two tuples
# not necessarily equal length !

function FTuple(from :: NTuple{N, Int}, to :: NTuple{M, Int}) where N where M
    funs = tuple(map(x -> ExtendedResidueFunction(from, x), to)...)
    return FTuple(funs)
end


# creating functional product from dom and codom

function FTuple(dom :: AbstractProduct, codom :: AbstractProduct)
    #fromto = zip(from, to)
    #funs = tuple(map(ResidueFunction, fromto)...)
    #return FProd(funs)
    from = size(dom)
    to = size(codom)
    return FTuple(from, to)
end



FProd(factors...) = FProd(tuple(factors...))
FTuple(factors...) = FTuple(tuple(factors...))
