"""
generic type for discrete function Dom -> Rng
"""
struct DiscreteFunction{D <: AbstractFiniteSet, R <: AbstractFiniteSet, A, B} <: AbstractDiscreteFunction
    m :: Dict{A, B}
    dom :: D
    rng :: R
end

const DFun = DiscreteFunction

function DiscreteFunction(d :: Dict{A, B}) where {A, B}
    min_x = minimum(keys(d))
    max_x = maximum(keys(d))
    min_y = minimum(values(d))
    max_y = maximum(values(d))
    D = Segment(min_x, max_x)
    R = Segment(min_y, max_y)
    return DiscreteFunction(d, D, R)
end

domain(df :: DiscreteFunction) = df.dom
codomain(df :: DiscreteFunction) = df.rng