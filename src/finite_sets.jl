#########################################
# different types of domains and ranges #
#########################################

abstract type AbstractFiniteSet end
const FinSet = AbstractFiniteSet

abstract type AbstractSegment <: FinSet end
abstract type AbstractProduct <: FinSet end


####### INTERFACES ###########

iterator(finset :: FinSet) = error("not implemented")
factors(aprod :: AbstractProduct) = error("not implemented")


#######################
# iteration utilities #
#######################

first(s :: AbstractSegment) = first(iterator(s))
last(s :: AbstractSegment) = last(iterator(s))
iterate(s :: FinSet) = iterate(iterator(s))
iterate(s :: FinSet, state) = iterate(iterator(s), state)
length(s :: FinSet) = length(iterator(s))
ndims(s :: FinSet) = ndims(iterator(s))
size(s :: FinSet) = size(iterator(s))

proj(aprod :: AbstractProduct, i) = factors(aprod)[i]
getindex(aprod :: AbstractProduct, i) = proj(aprod, i)





#####################
# main files ########
#####################
include("finsets/segment.jl")
include("finsets/direct_prod.jl")



function Base.show(io :: IO, s :: AbstractSegment)
    print(io, "[", first(s), "..", last(s), "]")
end


function Base.show(io :: IO, dp :: DirectProduct)
    res = ""
    for x in factors(dp)
        res *= repr(x)
        res *= "×"
    end
    print(io, res[1 : end-1])
end
