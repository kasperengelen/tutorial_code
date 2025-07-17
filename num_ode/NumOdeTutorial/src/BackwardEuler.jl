
using Plots
using NonlinearSolve

include("./InitialValueProblem.jl")
include("./IVPSolver.jl")

"""
    solveBackwardEuler(;ivp::InitialValueProblem, stepSize::Float64)::Vector{Tuple{Float64,Float64}}

    Solve the specified IVP using the backward Euler method with the specified step-size.
    The `RobustMultiNewton` solver from the `NonlinearSolve.jl` package is used to
    solve the non-linear equations resulting from the backward Euler formula.
    
    At every step the function and time values are stored. The return value is a vector
    of tuples `(t,y)`.
"""
function solveBackwardEuler(;ivp::InitialValueProblem, stepSize::Float64)::Vector{Tuple{Float64,Float64}}

    # set some values
    currentVal::Float64 = ivp.initialValue
    currentTime::Float64 = ivp.initialTime

    # add initial condition to the list of output values
    funcVals = [(currentTime, currentVal)]

    while (currentTime + stepSize) <= ivp.endTime
        # increase time from t_i to t_i+1
        nextTime = currentTime + stepSize

        currentVal = solveNonLinearEquation(ivp.diffEq, currentTime, currentVal, nextTime, stepSize)
        currentTime = nextTime

        # store value (t_i+1, y_i+1)
        push!(funcVals, (currentTime, currentVal))
    end

    return funcVals
end


"""
    solveNonLinearEquation(diffEq::Function, currentTime::Float64, currentValue::Float64, nextTime::Float64, stepSize::Float64)::Float64

    Solve the non-linear equation from the implicit Euler method,
    for the specified system of differential equations. `currentValue` is
    the value y_i. `currentTime` is the current timestep. The solution is the value y_{i+1}.
"""
function solveNonLinearEquation(diffEq::Function, currentTime::Float64, currentValue::Float64, nextTime::Float64, stepSize::Float64)::Float64
    # use forward Euler to obtain the starting value for our solver
    # forward Euler method formula y_i+1 = y_i + h * f(t_i, y_i)
    forwardEuler(currentValue) = currentValue + stepSize * diffEq(currentTime, currentValue)

    # call forward Euler to get an initial estimate
    u0 = forwardEuler(currentValue)

    # backward Euler method formula y_i+1 = y_i + h * f(t_i+1, y_i+1)
    backwardEuler(nextValue, p) = currentValue + stepSize * diffEq(nextTime, nextValue) - nextValue

    # solve non linear eq
    problem = NonlinearProblem(backwardEuler, u0)
    nextValue = solve(problem, RobustMultiNewton()).u

    return nextValue
end


"""
    BackwardEuler(stepSize::Float64)::IVPSolver

    Retrieve a backward Euler solver with the specified step size.
"""
function BackwardEuler(stepSize::Float64)::IVPSolver
    return IVPSolver(
        ivp -> solveBackwardEuler(ivp=ivp, stepSize=stepSize),
        "BE h=$(stepSize)"
    )
end
