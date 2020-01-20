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
    print(io, "[0, 1]^$(ndims(bc))")
end



function Base.show(io :: IO, f :: AbstractDiscreteFunction)
    d = domain(f)
    r = codomain(f)
    print(io, "Func f : ")
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



