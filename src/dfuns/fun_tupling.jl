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

const FTuple = FunTupling
