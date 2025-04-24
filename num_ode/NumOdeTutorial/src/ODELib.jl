

"""
    Represents an initial value problem, including:
        - the ODE,
        - the initial value,
        - the initial time, associated with the initial value,
        - the end time, upon which the solver should stop,
        - optionally, the exact solution to the IVP.
"""
struct InitialValueProblem
    diffEq
    initialValue
    initialTime
    endTime
    exactSolution
end


"""
    Retrieve a stable ODE that is easy to solve numerically.

    Source: https://www.math.umd.edu/~petersd/460/html/stableODEex.html
"""
function getStableODEProblem()::InitialValueProblem
    ode(t, y) = -y - sin(t) + cos(t)
    return InitialValueProblem(
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
        ode,
        1.0, # y0
        0.0, # t0
        5.0, # end time
        cos  # exact solution
    )
end
