
include("./InitialValueProblem.jl")


"""
    Retrieve a stable ODE that is easy to solve numerically.

    Source: https://www.math.umd.edu/~petersd/460/html/stableODEex.html
"""
function getStableODEProblem()::InitialValueProblem
    ode(t, y) = -y - sin(t) + cos(t)
    return InitialValueProblem(
        "Stable ODE",
        ode,
        1.0,  # y0
        0.0,  # t0
        10.0, # end time
        cos   # exact solution
    )
end


"""
    Retrieve an ODE that is inherently unstable, and impossible
    to solve numerically.

    Source: https://www.math.umd.edu/~petersd/460/html/stableODEex.html
"""
function getUnstableODEProblem()::InitialValueProblem
    ode(t, y) = y - sin(t) - cos(t) 
    return InitialValueProblem(
        "Unstable ODE",
        ode,
        1.0, # y0
        0.0, # t0
        5.0, # end time
        cos  # exact solution
    )
end


"""
    Retrieve a stiff ODE.

    Source: https://people.sc.fsu.edu/~jburkardt/classes/math1902_2020/stiff/stiff.pdf
"""
function getStiffODEProblem()::InitialValueProblem
    ode(t, y) = 50 * (cos(t) - y)
    sol(t) = 50.0 * ((sin(t) + 50.0 * cos(t) - 50.0 * exp(-50.0 * t)) / (2501.0))
    return InitialValueProblem(
        "Simple Stiff ODE",
        ode,
        0.0, # x0
        0.0, # t0
        1.0, # tf
        sol
    )
end


"""
    Retrieve a stiff ODE.

    Source: https://people.sc.fsu.edu/~jburkardt/classes/math1902_2020/stiff/stiff.pdf
"""
function getQuadexODEProblem()::InitialValueProblem
    ode(t, y) = 5 * (y - t^2)
    sol(t) = t^2 + ((2.0*t)/5.0) + (2.0/25.0)
    return InitialValueProblem(
        "\"QUADEX\" ODE",
        ode,
        2.0 / 25.0, # x0
        0.0, # t0
        2.0, # tf
        sol
    )
end


"""
    Stiff ODE.
    
    https://www.dam.brown.edu/people/alcyew/handouts/numODE5.pdf
"""
function getStiffODEProblemFlame(init::Float64)::InitialValueProblem
    ode(t, y) = y^2 - y^3
    return InitialValueProblem(
        "Flame ODE",
        ode,
        init, # x0
        0.0, # t0
        2.0 / init, # tf
        nothing
    )
end


"""
    A Riccati equation.
"""
function getRiccatiODEProblem()::InitialValueProblem
    ode(t, y) = -y^2 + t
    init = 4.0
    return InitialValueProblem(
        "Ricatti ODE",
        ode,
        init, # x0
        0.0, # t0
        1.0, # tf
        nothing
    )
end
