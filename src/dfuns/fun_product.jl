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

const FProd = FunProduct
