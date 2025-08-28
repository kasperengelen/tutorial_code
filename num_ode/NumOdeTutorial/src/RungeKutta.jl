

include("./InitialValueProblem.jl")
include("./IVPSolver.jl")

using LinearAlgebra


"""
    Solve the specified initial-value problem using the Runge-Kutta method. The arguments
    are the RK matrix `a`, the weights `b`, and the nodes `c`, the number of stages `numStages`,
    and the step-size `stepSize`.
"""
function solveRungeKuttaExplicit(;
    ivp::InitialValueProblem, stepSize::Float64, 
    numStages::Int64, 
    a::Matrix{Float64}, b::Vector{Float64}, c::Vector{Float64}
)::Vector{Tuple{Float64,Float64}}

    # check that the dimensions of a,b,c match the specified order
    if size(a) != (numStages, numStages)
        throw(ArgumentError("Error: the number of stages do not correspond
            with the dimensions of 'a'."))
    end

    if size(b) != (numStages,)
        throw(ArgumentError("Error: the number of stages do not correspond
            with the dimensions of 'b'."))
    end

    if size(c) != (numStages,)
        throw(ArgumentError("Error: the number of stages do not correspond
            with the dimensions of 'c'."))
    end

    # set some values
    currentVal::Float64 = ivp.initialValue
    currentTime::Float64 = ivp.initialTime

    # add initial condition to the list of output values
    funcVals = [(currentTime, currentVal)]

    while (currentTime + stepSize) <= ivp.endTime
        # compute next value
        currentVal = rungeKuttaStepExplicit(ivp=ivp, stepSize=stepSize, 
            currentTime=currentTime, currentVal=currentVal,
        numStages=numStages, a=a, b=b, c=c)
        currentTime = currentTime + stepSize

        # store next value
        push!(funcVals, (currentTime, currentVal))
    end

    return funcVals
end


"""
    Produce a single step of the Runge-Kutta method. It will take the
    current value `currentVal` and current time `currentTime` and produce
    a new value at time `currentTime + stepSize`. The arguments are 
    the RK matrix `a`, the weights `b`, and the nodes `c`, the number 
    of stages `numStages`, and the step-size `stepSize`.
"""
function rungeKuttaStepExplicit(;
    ivp::InitialValueProblem, stepSize::Float64, 
    currentTime::Float64, currentVal::Float64, 
    numStages::Int64, 
    a::Matrix{Float64}, b::Vector{Float64}, c::Vector{Float64})::Float64

    # verify that the first row is zero
    if !iszero(a[1, 1:end])
        throw(ArgumentError("Error: this function only supports explicit 
            RK methods, but an implicit coefficient matrix was passed."))
    end

    k_vals = [ivp.diffEq(currentTime, currentVal)]

    # iterate
    for s in 2:numStages
        # compute time value
        time_val = currentTime + c[s] * stepSize

        # compute function value
        a_vec = a[s, 1:s-1]
        if !iszero(a[s, s:end])
            throw(ArgumentError("Error: this function only supports explicit 
                RK methods, but an implicit coefficient matrix was passed."))
        end
        y_val = currentVal + stepSize * dot(a_vec, k_vals)

        # evaluate ODE
        k_val = ivp.diffEq(time_val, y_val)
        push!(k_vals, k_val)
    end

    # compute weighted sum
    return currentVal + stepSize * dot(b, k_vals)
end


"""
    Fourth order Runge Kutta method with Martin Kutta's 1901 coordinates.
"""
function RK4Kutta(stepSize::Float64)
    return IVPSolver(
        ivp -> solveRungeKuttaExplicit(ivp=ivp, stepSize=stepSize, numStages=4, 
        a=[0 0 0 0; 1/2 0 0 0; 0 1/2 0 0; 0 0 1 0],
        b=[1/6, 1/3, 1/3, 1/6],
        c=[0, 1/2, 1/2, 1]),
        "RK4 Kutta h=$(stepSize)"
    )
end


"""
    Third order Runge Kutta method with Martin Kutta's 1901 coordinates.
"""
function RK3Kutta(stepSize::Float64)
    return IVPSolver(
        ivp -> solveRungeKuttaExplicit(ivp=ivp, stepSize=stepSize, numStages=3, 
        a=[0 0 0; 1/2 0 0; -1 2 0],
        b=[1/6, 2/3, 1/6],
        c=[0, 1/2, 1]),
        "RK3 Kutta h=$(stepSize)"
    )
end

"""
    Third order Heun's method.    

    According to Burden and Faires, this is the most common 3rd order RK method.
"""
function RK3Heun(stepSize::Float64)
    return IVPSolver(
        ivp -> solveRungeKuttaExplicit(ivp=ivp, stepSize=stepSize, numStages=3, 
        a=[0 0 0; 1/3 0 0; 0 2/3 0],
        b=[1/4, 0, 3/4],
        c=[0, 1/2, 2/3]),
        "RK3 Heun h=$(stepSize)"
    )
end


"""
    Second order midpoint method.
"""
function RK2Midpoint(stepSize::Float64)
    return IVPSolver(
        ivp -> solveRungeKuttaExplicit(ivp=ivp, stepSize=stepSize, numStages=2, 
        a=[0 0; 1/2 0],
        b=[0.0, 1.0],
        c=[0.0, 1/2]),
        "RK2 Midpoint h=$(stepSize)"
    )
end


"""
    Second order Heun's method.
"""
function RK2Heun(stepSize::Float64)
    return IVPSolver(
        ivp -> solveRungeKuttaExplicit(ivp=ivp, stepSize=stepSize, numStages=2, 
        a=[0 0; 1 0],
        b=[0.5, 0.5],
        c=[0.0, 1]),
        "RK2 Heun h=$(stepSize)"
    )
end


"""
    Second order Ralson's method.
"""
function RK2Ralston(stepSize::Float64)
    return IVPSolver(
        ivp -> solveRungeKuttaExplicit(ivp=ivp, stepSize=stepSize, numStages=2, 
        a=[0 0; 2/3 0],
        b=[1/4, 3/4],
        c=[0.0, 2/3]),
        "RK2 Ralston h=$(stepSize)"
    )
end
