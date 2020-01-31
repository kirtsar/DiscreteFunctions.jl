using DiscreteFunctions
using Test


@testset "Segment"
    s1 = Segment(3)
    s2 = Segment(1, 3)
    @test iterator(s1) = 0 : 2
    @test iterator(s2) = 1 : 3
    @test first(s1) == 0
    @test last(s2) == 3
    @test length(s1) == 3
    @test length(s2) == 3
    # iterators
    s = 0
    for x in s1
        s += x
    end
    @test s == 2
    s = 0
    for x in s2
        s += x
    end
    @test s == 6
    @test ndims(s1) == 1
    @test size(s1) == (3,)
end


@testset "BooleanCube"
    bc = BooleanCube(5)
    @test length(bc) == 2^5
    # iterators 
    s = 0
    for x in bc
        s += value(x)
    end
    @test s == 496
end


@testset "Direct product"
    bc = BooleanCube(5)
    s1 = Segment(3)
    dp = DirectProduct(bc, s1)
    @test length(bc) == 2^5 * 3 
    s = 0
    for x in bc
        s += value(x)
    end
    @test s == 496
end
