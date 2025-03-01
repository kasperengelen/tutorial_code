
module ForwardEuler

using Plots

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

    for i in 0:numSteps-1
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
    exampleODE1(t, y)

Return the derivative `y'(t)` at function value `y` and time value `t`. 

This is an unstable ODE. Source: https://www.math.umd.edu/~petersd/460/html/stableODEex.html
"""
function exampleODE1(t, y)
    return y - sin(t) - cos(t) 
end

"""
    exampleODE2(t, y)

Return the derivative `y'(t)` at function value `y` and time value `t`. 

This is a stable ODE. Source: https://www.math.umd.edu/~petersd/460/html/stableODEex.html
"""
function exampleODE2(t, y)
    return  -y - sin(t) + cos(t)
end


"""
    runExample1()

Run the example with `exampleODE1`.
"""
function runExample1()
    initial_cond = 1.0
    t0 = 0.0
    tn = 5.0

    functionValues = solveForwardEuler(exampleODE1, y0=initial_cond, t0=t0, tn=tn, numSteps=5)
    plot(functionValues, markershape = :auto, label="h=$(tn/5)", 
            title="y' = y - sin(t) - cos(t); y(0) = 1", ylabel="y", xlabel="t")
    
    functionValues = solveForwardEuler(exampleODE1, y0=initial_cond, t0=t0, tn=tn, numSteps=10)
    plot!(functionValues, markershape = :auto, label="h=$(tn/10)")
    
    functionValues = solveForwardEuler(exampleODE1, y0=initial_cond, t0=t0, tn=tn, numSteps=50)
    plot!(functionValues, markershape = :auto, label="h=$(tn/50)")
    
    functionValues = solveForwardEuler(exampleODE1, 
    y0=initial_cond, t0=t0, tn=tn, numSteps=1000)
    plot!(functionValues, label="h=$(tn/1000)")

    plot!(cos, t0, tn, label="cos(t)", dpi=500)

    savefig("./ForwardEuler1.png")
end


"""
    runExample2()

Run the example with `exampleODE2`.
"""
function runExample2()
    initial_cond = 1.0
    t0 = 0.0
    tn = 10.0

    functionValues = solveForwardEuler(exampleODE2, y0=initial_cond, t0=t0, tn=tn, numSteps=10)
    plot(functionValues, markershape = :auto, label="h=$(tn/10)", 
            title="y'= - y - sin(t) + cos(t); y(0) = 1", ylabel="y", xlabel="t")
    
    functionValues = solveForwardEuler(exampleODE2, 
    y0=initial_cond, t0=t0, tn=tn, numSteps=20)
    plot!(functionValues, markershape = :auto, label="h=$(tn/20)")
    
    functionValues = solveForwardEuler(exampleODE2, y0=initial_cond, t0=t0, tn=tn, numSteps=100)
    plot!(functionValues, markershape = :auto, label="h=$(tn/100)")
    
    functionValues = solveForwardEuler(exampleODE2, y0=initial_cond, t0=t0, tn=tn, numSteps=2000)
    plot!(functionValues, label="h=$(tn/2000)")

    plot!(cos, t0, tn, label="cos(t)", dpi=500)

    savefig("./ForwardEuler2.png")
end


# run the program
if abspath(PROGRAM_FILE) == @__FILE__
    runExample1()
    runExample2()
end

end