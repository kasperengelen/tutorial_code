
using Plots
using NonlinearSolve

include("./ODELib.jl")

"""
    solveBackwardEuler(diffEq; y0::Float64, t0::Float64, tn::Float64, numSteps::Integer)

    Solve the ODE given by `diffEq`. The `diffEq` function takes two arguments `t` and `y` which
    are the current time and function values, respectively, and returns the derivative of `y` at that time point.

    The ODE will be solved from time `t0` until `tn` with initial condition `y0`. The 
    step-size is equal to `h = (tn-t0)/numSteps`.
    
    At every step the function and time values are stored. The return value is a vector
    of tuples `(t,y)`.
"""
function solveBackwardEuler(diffEq; y0::Float64, t0::Float64, tn::Float64, numSteps::Integer)

    # set some values
    stepSize = (tn-t0)/numSteps
    currentVal::Float64 = y0
    currentTime::Float64 = t0

    # add initial condition to the list of output values
    funcVals = [(currentTime, currentVal)]

    for _ in 0:numSteps-1
        # increase time from t_i to t_i+1
        nextTime = currentTime + stepSize

        currentVal = solveNonLinearEquation(diffEq, currentTime, currentVal, nextTime, stepSize)
        currentTime = nextTime

        # store value (t_i+1, y_i+1)
        push!(funcVals, (currentTime, currentVal))
    end

    return funcVals
end


"""
    solveNonLinearEquation(diffEq, currentTime, yCur, nextTime, stepSize)

    Solve the non-linear equation from the implicit Euler method,
    for the specified system of differential equations. `yCur` is
    the value y_i. The solution is the value y_{i+1}.
"""
function solveNonLinearEquation(diffEq, currentTime::Float64, yCur::Float64, nextTime::Float64, stepSize::Float64)
    # use forward Euler to obtain the starting value for our solver
    # forward Euler method formula y_i+1 = y_i + h * f(t_i, y_i)
    forwardEuler(yCur) = yCur + stepSize * diffEq(currentTime, yCur)

    # call forward Euler to get an initial estimate
    u0 = forwardEuler(yCur)

    # backward Euler method formula y_i+1 = y_i + h * f(t_i+1, y_i+1)
    backwardEuler(yNext, p) = yCur + stepSize * diffEq(nextTime, yNext) - yNext

    # solve non linear eq
    problem = NonlinearProblem(backwardEuler, u0)
    nextVal = solve(problem, RobustMultiNewton()).u

    # update values
    currentVal = nextVal

    return currentVal
end


"""
    solveAndPlotBackwardEuler(ivp::InitialValueProblem, stepCounts::Vector{Int}, filename::String)

    Solve the specified IVP using the forward Euler method. The `stepCounts` argument is an array with different numbers
    of steps that will be used. All trajectories, including the exact solution, will be plotted and stored in the specified file.
"""
function solveAndPlotBackwardEuler(ivp::InitialValueProblem, stepCounts::Vector{Int}, filename::String)
    for numSteps in stepCounts
        # solve for every step size and plot
        functionValues = solveBackwardEuler(ivp.diffEq, y0=ivp.initialValue, t0=ivp.initialTime, tn=ivp.endTime, numSteps=numSteps)
        stepSize = (ivp.endTime - ivp.initialTime) / numSteps
        if numSteps <= 200
            plot!(functionValues, markershape = :auto, label="h=$(stepSize)", dpi=500)
        else
            plot!(functionValues, label="h=$(stepSize)", dpi=500)
        end
    end

    if ivp.exactSolution !== nothing
        # if an exact solution exists, we plot it
        plot!(ivp.exactSolution, ivp.initialTime, ivp.endTime, label="Exact solution", dpi=500)
    end
    savefig(filename)
end
