using DiscreteFunctions
using Test

@testset "segment construction"
    s1 = segment(3)
    s2 = segment(1, 3)
    @test s1.itr = 0 : 2
    @test s2.itr = 1 : 3
end

@testset "iteration utilities" begin
    bc = BooleanCube(3)
    @test collect(bc) == [
         (0, 0, 0)
         (0, 0, 1)
         (0, 1, 0)
         (0, 1, 1)
         (1, 0, 0)
         (1, 0, 1)
         (1, 1, 0)
         (1, 1, 1)
    ]
end
