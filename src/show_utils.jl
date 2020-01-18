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


function Base.show(io :: IO, bc :: BooleanCube)
    print(io, "[0, 1]^$(len(bc))")
end



function Base.show(io :: IO, map :: AbstractDiscreteFunction)
    d = dom(map)
    r = rng(map)
    print("Func f : ")
    print(io, d)
    print(io, " -> ")
    print(io, r)
end 

