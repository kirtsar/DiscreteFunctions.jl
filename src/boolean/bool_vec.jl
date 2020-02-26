#### Boolean vectors

struct BooleanVector
    k :: Int
    n :: Int
end

const BoolVec = BooleanVector
const BooleanVec = BooleanVector

BoolVec(vs :: Union{NTuple, Vector}) = BoolVec(itr2bin(vs), length(vs))
value(v :: BoolVec) = v.k

function getindex(v :: BoolVec, i :: Int)
    n = ndims(v)
    return (value(v) >> (n - i)) & 1 
end

ndims(v :: BoolVec) = v.n
length(v :: BoolVec) = ndims(v)
iterate(v :: BoolVec) = (v[1], 2)
iterate(v :: BoolVec, i :: Int) = i > ndims(v) ? nothing : (v[i], i+1)

dot(v1 :: BoolVec, v2 :: BoolVec) = sum(collect(v1) .* collect(v2)) % 2
# v1 <= v2 in lexicographic order?
isless(v1 :: BoolVec, v2 :: BoolVec) = (value(v1) & value(v2) == value(v1))
function Base.show(io :: IO, v :: BoolVec)
    n = ndims(v) - 1
    s = bitstring(value(v))[end - n : end]
    print(io, "[", s, ']')
end

# change representation to BoolVec
(bc :: BCube)(x :: Union{NTuple, Array}) = BoolVec(x)
(bc :: BCube)(x :: Int) = x