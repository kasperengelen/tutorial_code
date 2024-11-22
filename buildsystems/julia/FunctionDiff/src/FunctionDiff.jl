

module FunctionDiff

using Polynomials
using Plots

"""
    getPolynomial(coeffs::Array{Float64})

Construct a polynomial from the specified coefficients. The coefficients are
ordered from low to high degree.
"""
function getPolynomial(coeffs::Array{Float64})
    return Polynomial(coeffs)
end


"""
    getDerivative(polynomial::Polynomial)

Take the derivative of the specified polynomial.
"""
function getDerivative(polynomial::Polynomial)
    return derivative(polynomial)
end


"""
    getHigherDerivative(polynomial::Polynomial, order::Int)

Take the n-th order derivative of the specified polynomial.
"""
function getHigherDerivative(polynomial::Polynomial, order::Int)
    higher_derivative = polynomial
    for i in 0:order-1
        higher_derivative = getDerivative(higher_derivative)
    end
    return higher_derivative
end


"""
    plotFunction(f::Polynomial, derivative::Polynomial)

This function will plot the specified polynomial and its derivative on the 
domain x \\in [-3.0, 3.0]. The image is restricted to y \\in [-3.0, 3.0].

The plot object will be returned.
"""
function plotFunction(polynom::Polynomial, derivative::Polynomial)
    # compute values
    x = range(-3.0, 3.0, length=100)
    func_values = polynom.(x)
    deriv_values = derivative.(x)

    # plot values
    pl = plot(x, [func_values, deriv_values], title="Function and derivative", 
              label=["f(x)" "derivative"], dpi=500)
    ylims!(-3.0, 3.0)
    
    return pl
end

end
