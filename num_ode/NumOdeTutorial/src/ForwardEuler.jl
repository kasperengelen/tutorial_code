

using Plots

include("./ODELib.jl")

"""
    solveForwardEuler(diffEq; y0::Float64, t0::Float64, tn::Float64, numSteps::Integer)

    Solve the ODE given by `diffEq`. The `diffEq` function takes two arguments `t` and `y` which
    are the current time and function values, respectively, and returns the derivative of `y` at that point.

    The ODE will be solved from time `t0` until `tn` with initial condition `y0`. The 
    step-size is equal to `h = (tn-t0)/numSteps`.
    
    At every step the function and time values are stored. The return value is a vector
    of tuples `(t,y)`.
"""
function solveForwardEuler(diffEq; y0::Float64, t0::Float64, tn::Float64, numSteps::Integer)

    # set some values
    stepSize = (tn-t0)/numSteps
    currentVal::Float64 = y0
    currentTime::Float64 = t0

    # add initial condition to the list of output values
    funcVals = [(currentTime, currentVal)]

    for _ in 0:numSteps-1
        # apply forward Euler method formula y_i+1 = y_i + h * f(t_i, y_)
        currentVal = currentVal + stepSize * diffEq(currentTime, currentVal)

        # increase time from t_i to t_i+1
        currentTime += stepSize

        # store value (t_i+1, y_i+1)
        push!(funcVals, (currentTime, currentVal))
    end

    return funcVals
end


"""
    solveAndPlotForwardEuler(ivp::InitialValueProblem, stepCounts::Vector{Int}, filename::String)

    Solve the specified IVP using the forward Euler method. The `stepCounts` argument is an array with different numbers
    of steps that will be used. All trajectories, including the exact solution, will be plotted and stored in the specified file.
"""
function solveAndPlotForwardEuler(ivp::InitialValueProblem, stepCounts::Vector{Int}, filename::String)
    for numSteps in stepCounts
        # solve for every step size and plot
        functionValues = solveForwardEuler(ivp.diffEq, y0=ivp.initialValue, t0=ivp.initialTime, tn=ivp.endTime, numSteps=numSteps)
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
