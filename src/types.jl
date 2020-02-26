abstract type AbstractDiscreteFunction end
const ADFun = AbstractDiscreteFunction
abstract type CompositeFunction <: ADFun end
abstract type BasicDiscreteFunction <: ADFun end


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
proj(f :: CompositeFunction, i) = factors(f)[i]
Base.getindex(f :: CompositeFunction, i) = proj(f, i)
Base.setindex!(ft :: CompositeFunction, v :: NTuple, k...) = ft[tuple(k...)] = v

rng(m :: AbstractDiscreteFunction) = codomain(m)
# number of functions 
size(comp :: CompositeFunction) = length(comp.factors)

include("dfuns/generic.jl")
include("dfuns/residue_fun.jl")
include("dfuns/fun_product.jl")
include("dfuns/fun_tupling.jl")


function Base.show(io :: IO, f :: AbstractDiscreteFunction)
    d = domain(f)
    r = codomain(f)
    print(io, "Fun f : ")
    print(io, d)
    print(io, " -> ")
    print(io, r)
end


function Base.summary(f :: AbstractDiscreteFunction)
    d = domain(f)
    r = codomain(f)
    println("Domain : ", d)
    println("Codomain : ", r)
    for x in tablegen(f)
        println(x)
    end
end


# returns generator of type x => f(x)
function tablegen(f :: AbstractDiscreteFunction)
    d = domain(f)
    res = (x => f(x) for x in d)
    return res
end
