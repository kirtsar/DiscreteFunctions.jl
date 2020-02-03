struct Monom
    v :: Int
end

# algebraic normal form of bool fun
# up to 63 variables
struct ANF
    monoms :: Vector{Monom}
end


value(m :: Monom) = m.v
arity(anf :: ANF) = anf.arity
monoms(anf :: ANF) = anf.monoms
Base.iszero(m :: Monom) = (value(m) == 0)
Base.isone(m :: Monom) = (value(m) == -1)

function Base.iszero(anf :: ANF)
    check1 = length(monoms(anf)) == 1
    check2 = iszero(monoms(anf)[1])
    return check1 && check2
end

function Base.isone(anf :: ANF) 
    check1 = length(monoms(anf)) == 1
    check2 = isone(monoms(anf)[1])
    return check1 && check2
end

function (m :: Monom)(vs)
    if isone(m)
        return true
    elseif iszero(m)
        return false
    else
        val = itr2bin(reverse(vs))
        return (value(m) & val) == value(m)
    end
end

(m :: Monom)(vs...) = m(tuple(vs...))
(anf :: ANF)(vs) = reduce(xor, [m(vs) for m in monoms(anf)])
(anf :: ANF)(vs...) = anf(tuple(vs...))


function Monom(v :: BoolVec)
    if value(v) == 0
        return Monom(-1)
    else
        return collect(Bool, v) |> reverse |> itr2bin |> Monom
    end
end


function ANF(ms :: Vector{T}) where T
    mons = [Monom(set_bits(m)) for m in ms]
    return ANF(mons)
end


prev(x, dom) = filter(y -> all(y .<= x), dom)


# given bool fun
# construct ANF
function ANF(f :: BoolFun)
    dom = collect(domain(f))
    mons = Vector{Monom}([])
    for x in dom
        ys = filter(t -> (t <= x), dom)
        ha = sum(f, ys) % 2
        if ha == 1
            push!(mons, Monom(x))
        end
    end
    if isempty(mons)
        push!(mons, Monom(0))
    end
    return ANF(mons)
end


# given ANF
# construct bool fun
function BoolFun(anf :: ANF)
    dom = collect(domain(f))
    mons = Vector{Monom}([])
    for x in dom
        ys = filter(t -> (t <= x), dom)
        ha = sum(f, ys) % 2
        if ha == 1
            push!(mons, Monom(x))
        end
    end
    if isempty(mons)
        push!(mons, Monom(0))
    end
    return ANF(mons)
end


# given bool func, find its Walsh-Hadamard spectrum
function spectrum(f :: BoolFun)
    g = BooleanDiscrete(domain(f))
    for y in domain(g)
        res = 0
        for x in domain(f)
            res += (-1)^(dot(x, y) + f(x))
        end
        g[y] = res
    end
    return g
end



function Base.show(io :: IO, m :: Monom)
    res = ""
    if iszero(m)
        res *= "0"
    elseif isone(m)
        res *= "1"
    else
        v = value(m)
        i = 0
        while v > 0 
            i += 1
            ind = v & 1
            if ind != 0
                res *= "x$i"
            end
            v >>= 1
        end
    end
    print(io, res)
end


function Base.show(io :: IO, anf :: ANF)
    res = reduce((x, y) -> x * " ⊕ " * y, repr.(monoms(anf)))
    print(io, res)
end





