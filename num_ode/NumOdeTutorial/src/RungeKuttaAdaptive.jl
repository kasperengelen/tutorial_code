

include("./InitialValueProblem.jl")
include("./IVPSolver.jl")

using LinearAlgebra


"""
    Solve the specified initial-value problem using the Runge-Kutta method with adaptive
    step-sizes.

    Arguments:
        - `ivp`: the IVP that will be solved.
        - `initStepSize`: the step size that will be used initially,
        - `atol`: the absolute error tolerance for the local truncation error,
        - `minStepSize`: the minimum step size,
        - `maxStepSize`: the maxmimum step size,
        - `minStepScale`: the minimum value for the scaling factor q,
        - `maxStepScale`: the maximum value for the scaling factor q,
        - `safetyFactor`: the conservative safety factor by which we multiply the step-size, 
        - `numStages`: the number of Runge-Kutta stages to compute,
        - `a`: the coefficient matrix of the different stages,
        - `bLowerOrder`: the weights to compute the lower order estimation,
        - `bHigherOrder`: the weights for the heigher order estimation,
        - `c`: the nodes.
"""
function solveRungeKuttaAdaptiveExplicit(; # force caller to use keywords
    ivp::InitialValueProblem, 
    initStepSize::Float64,
    atol::Float64,
    minStepSize::Float64, 
    maxStepSize::Float64, 
    minStepScale::Float64, 
    maxStepScale::Float64, 
    safetyFactor::Float64,
    numStages::Int64,
    a::Matrix{Float64}, 
    bLowerOrder::Vector{Float64}, 
    bHigherOrder::Vector{Float64}, 
    c::Vector{Float64}
)::Vector{Tuple{Float64,Float64}}
    # check that the dimensions of a,b,c match the specified number of stages
    if size(a) != (numStages, numStages)
        throw(ArgumentError("Error: the number of stages does not correspond
            with the dimensions of 'a'."))
    end

    if size(bHigherOrder) != (numStages,)
        throw(ArgumentError("Error: the number of stages does not correspond
            with the dimensions of 'bHigherOrder'."))
    end

    if size(bLowerOrder) != (numStages,)
        throw(ArgumentError("Error: the number of stages does not correspond
            with the dimensions of 'bLowerOrder'."))
    end

    if size(c) != (numStages,)
        throw(ArgumentError("Error: the number of stages does not correspond
            with the dimensions of 'c'."))
    end

    # set some values
    currentVal::Float64 = ivp.initialValue
    currentTime::Float64 = ivp.initialTime

    # add initial condition to the list of output values
    funcVals = [(currentTime, currentVal)]

    # we begin with the maximum step size, for efficiency
    stepSize = initStepSize

    while (currentTime + stepSize) <= ivp.endTime
        # compute next value
        currentVal, usedStepSize = _rungeKuttaStepAdaptiveExplicit_(
            ivp=ivp, 
            currentTime=currentTime, 
            currentVal=currentVal, 
            initStepSize=stepSize,
            atol=atol,
            minStepSize=minStepSize, 
            maxStepSize=maxStepSize, 
            minStepScale=minStepScale, 
            maxStepScale=maxStepScale, 
            safetyFactor=safetyFactor,
            numStages=numStages,
            a=a, 
            bLowerOrder=bLowerOrder, 
            bHigherOrder=bHigherOrder, 
            c=c,
        )
        currentTime = currentTime + usedStepSize

        stepSize = usedStepSize

        # store next value
        push!(funcVals, (currentTime, currentVal))
    end

    return funcVals
end


"""
    Solve a single step of the IVP using two embedded Runge Kutta methods with different stages. 
    The used step-size will be chosen dynamically to bound the local truncation error, starting 
    from the specified step-size.

    The error will be estimated using the difference between higher and lower order estimations.

    If the adjusted step-size is lower than `minStepSize`, an exception will be raised. If the adjusted
    step-size is higher than the maximum, it will be capped to the maximum.

    The scale factors are also bounded: if they go beyond the bounds then they are clipped to the bounds.

    Arguments:
        - `ivp`: the IVP that will be solved.
        - `currentTime`: the starting time of the step,
        - `currentVal`: the starting value of the step,
        - `initStepSize`: the step-size that will be used initially,
        - `atol`: the absolute error tolerance for the local truncation error,
        - `minStepSize`: the minimum step-size,
        - `maxStepSize`: the maxmimum step-size,
        - `minStepScale`: the minimum value for the scaling factor q,
        - `maxStepScale`: the maximum value for the scaling factor q,
        - `safetyFactor`: the conservative safety factor by which we multiply the step-size,
        - `numStages`: the number of stages to compute,
        - `a`: the coefficient matrix of the different stages,
        - `bLowerOrder`: the weights to compute the lower order estimation,
        - `bHigherOrder`: the weights for the heigher order estimation,
        - `c`: the nodes.
"""
function _rungeKuttaStepAdaptiveExplicit_(; # force caller to use keywords
    ivp::InitialValueProblem, 
    currentTime::Float64, 
    currentVal::Float64, 
    initStepSize::Float64,
    atol::Float64,
    minStepSize::Float64, 
    maxStepSize::Float64, 
    minStepScale::Float64, 
    maxStepScale::Float64, 
    safetyFactor::Float64,
    numStages::Int64,
    a::Matrix{Float64}, 
    bLowerOrder::Vector{Float64}, 
    bHigherOrder::Vector{Float64}, 
    c::Vector{Float64},
)::Tuple{Float64, Float64}

    stepSize = initStepSize

    while true
        # compute value, error
        nextValue, error = _rungeKuttaWithErrorEstFixedStep_(
            ivp=ivp, 
            currentTime=currentTime, 
            currentVal=currentVal, 
            numStages=numStages, 
            stepSize=stepSize,
            a=a, 
            bLowerOrder=bLowerOrder, 
            bHigherOrder=bHigherOrder, 
            c=c
        )

        # sanity check to catch bugs
        if error < 0
            throw(ArgumentError("Error: the local truncation error needs to be non-negative."))
        end

        # compute and limit q value
        q_val = (atol / error)^(1/5)
        q_adjusted = max(minStepScale, min(maxStepScale, q_val))

        # adjust step size
        stepSize = stepSize * safetyFactor * q_adjusted

        # if we arrive at a step size that is too small, then we stop the solver
        if stepSize < minStepSize
            throw(ErrorException("Error: tried shrinking the step size below the minimum step size, at time=$(currentTime). Exiting."))
        end

        # if the error is too high, then we repeat the computation with a smaller step-size
        if error > atol
            # repeat the computation with smaller step size
            continue
        end

        # we limit the step size if it gets too big
        if stepSize > maxStepSize
            stepSize = maxStepSize
        end

        return nextValue, stepSize
    end
end

"""
    Compute a single step of the trajectory using Runge-Kutta. This will also estimate the truncation error.

    The resulting value computing using the lower order Runge-Kutta method. The higher order is only
    used for the error estimation.

    Arguments:
        - `ivp`: the IVP that will be solved.
        - `currentTime`: the starting time of the step,
        - `currentVal`: the starting value of the step,
        - `numStages`: the number of stages to compute,
        - `stepSize`: the step-size that will be used,
        - `a`: the coefficient matrix of the different stages,
        - `bLowerOrder`: the weights to compute the lower order estimation,
        - `bHigherOrder`: the weights for the heigher order estimation,
        - `c`: the nodes.
"""
function _rungeKuttaWithErrorEstFixedStep_(; # force caller to use keywords
    ivp::InitialValueProblem, 
    currentTime::Float64, 
    currentVal::Float64, 
    numStages::Int64, 
    stepSize::Float64,
    a::Matrix{Float64}, 
    bLowerOrder::Vector{Float64}, 
    bHigherOrder::Vector{Float64}, 
    c::Vector{Float64}
    )::Tuple{Float64, Float64}

    # verify that the first row is zero
    if !iszero(a[1, 1:end])
        throw(ArgumentError("Error: this function only supports explicit 
            RK methods, but an implicit coefficient matrix was passed."))
    end

    k_vals = [ivp.diffEq(currentTime, currentVal)]

    # compute the different stages
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
    higherOrderEst = currentVal + stepSize * dot(bHigherOrder, k_vals)
    lowerOrderEst = currentVal + stepSize * dot(bLowerOrder, k_vals)

    errorEst = abs(higherOrderEst - lowerOrderEst)

    return lowerOrderEst, errorEst
end


"""
    The Runge-Kutta-Fehlberg method. This produces a fourth-order approximation of the IVP.
    This uses an adaptive-step algorithm where the step-size is automatically chosen based
    on an estimation of the local truncation error. This error is estimated using a
    fifth-order Runge-Kutta method.

    Arguments:
        - `atol`: the absolute error tolerance for the local truncation error,
        - `initStepSize`: the step size that will be used initially,
        - `minStepSize`: the minimum step size,
        - `maxStepSize`: the maxmimum step size,
        - `minStepScale`: the minimum value for the scaling factor q,
        - `maxStepScale`: the maximum value for the scaling factor q.
"""
function RKF45(;
    atol::Float64, 
    initStepSize::Float64,
    minStepSize::Float64,
    maxStepSize::Float64,
    minStepScale::Float64,
    maxStepScale::Float64,
)
    return IVPSolver(
        ivp -> solveRungeKuttaAdaptiveExplicit(; # force caller to use keywords
            ivp=ivp, 
            initStepSize=initStepSize,
            minStepSize=minStepSize,
            maxStepSize=maxStepSize,
            minStepScale=minStepScale,
            maxStepScale=maxStepScale,
            atol=atol,
            safetyFactor=0.9,  # Hairer
            numStages=6,
            a=[
                 0          0          0          0          0     0;
                 1/4        0          0          0          0     0;
                 3/32       9/32       0          0          0     0;
                 1932/2197 -7200/2197  7296/2197  0          0     0;
                 439/216   -8          3680/513  -845/4101   0     0;
                -8/27       2         -3544/2565  1859/4104 -11/40 0
            ], 
            bLowerOrder= [25/216, 0, 1408/2565,  2197/4101,   -1/5,  0], 
            bHigherOrder=[16/135, 0, 6656/12825, 28561/56430, -9/50, 2/55], 
            c=[0.0, 1/4, 3/8, 12/13, 1, 1/2]
        ),
        "RKF45 ATOL=$(atol)"
    )
end
