
include("./InitialValueProblem.jl")
include("./IVPSolver.jl")

"""
    solveForwardEuler(;ivp::InitialValueProblem, stepSize::Float64)::Vector{Tuple{Float64,Float64}}

    Solve the specified IVP using the forward Euler method with the specified step-size.
    
    At every step the function and time values are stored. The return value is a vector
    of tuples `(t,y)`.
"""
function solveForwardEuler(;ivp::InitialValueProblem, stepSize::Float64)::Vector{Tuple{Float64,Float64}}

    # set some values
    currentVal::Float64 = ivp.initialValue
    currentTime::Float64 = ivp.initialTime

    # add initial condition to the list of output values
    funcVals = [(currentTime, currentVal)]

    while (currentTime + stepSize) <= ivp.endTime
        # apply forward Euler method formula y_i+1 = y_i + h * f(t_i, y_)
        currentVal = currentVal + stepSize * ivp.diffEq(currentTime, currentVal)

        # increase time from t_i to t_i+1
        currentTime += stepSize

        # store value (t_i+1, y_i+1)
        push!(funcVals, (currentTime, currentVal))
    end
    
    return funcVals
end


"""
    ForwardEuler(stepSize::Float64)::IVPSolver

    Retrieve a forward Euler solver with the specified step size.
"""
function ForwardEuler(stepSize::Float64)::IVPSolver
    return IVPSolver(
        ivp -> solveForwardEuler(ivp=ivp, stepSize=stepSize),
        "FE h=$(stepSize)"
    )
end
