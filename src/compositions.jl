# generic fallback behaviour
DiscreteFunction(dom, cod) = error("not implemented")
# specific constructions
DiscreteFunction(dom :: Segment, cod :: Segment) = ResFun(dom, cod)
DiscreteFunction(dom :: AbstractProduct, cod :: Segment) = ExtFun(dom, cod)
DiscreteFunction(dom :: AbstractProduct, cod :: AbstractProduct) = FTuple(dom, cod)

# generic fallback
#is_composable(dom, cod) = false
#is_composable(rng :: Segment, dom :: Segment) = true
#is_composable(rng :: Segment, dom :: AbstractProduct) = false
#is_composable(rng :: DProd, dom :: DProd) = 

function ∘(f1 :: AbstractDiscreteFunction, f2 :: AbstractDiscreteFunction)
    dom = domain(f2)
    cod = codomain(f1)
    g = DiscreteFunction(dom, cod)
    for x in dom
        g[x] = f1(f2(x))
    end
    return g
end
