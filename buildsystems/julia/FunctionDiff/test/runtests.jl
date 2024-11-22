
using FunctionDiff
using Polynomials
using Test


@testset "FunctionDiffTests" begin
    @testset "getPolynomialTest" begin
        @test FunctionDiff.getPolynomial([-6.3344, 1.0, 2.0, -3.45, 4.0]) == Polynomial([-6.3344, 1.0, 2.0, -3.45, 4.0])
    end

    @testset "getDerivativeTest" begin
        @test FunctionDiff.getDerivative(Polynomial([1.0, 2.0, 3.0, 4.0])) == Polynomial([2.0, 6.0, 12.0])
    end

    @testset "getHigherDerivativeTest" begin
        @test FunctionDiff.getHigherDerivative(Polynomial([0, 3.0, 2.0, -6.0]), 1) == Polynomial([3.0, 4.0, -18.0])
        @test FunctionDiff.getHigherDerivative(Polynomial([0, 3.0, 2.0, -6.0]), 2) == Polynomial([4.0, -36.0])
        @test FunctionDiff.getHigherDerivative(Polynomial([0, 3.0, 2.0, -6.0]), 3) == Polynomial([-36.0])
    end
end
