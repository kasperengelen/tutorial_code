
include("./InitialValueProblem.jl")


"""
    Retrieve a stable ODE that is easy to solve numerically.

    Source: https://www.math.umd.edu/~petersd/460/html/stableODEex.html
"""
function getStableODEProblem()::InitialValueProblem
    ode(t, y) = -y - sin(t) + cos(t)
    return InitialValueProblem(
        "Stable cosine ODE",
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
        "Unstable cosine ODE",
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


"""
    A non-stiff ODE suitable for explicit solvers.

    Source: https://en.wikipedia.org/wiki/Runge%E2%80%93Kutta_methods#Derivation_of_the_Runge%E2%80%93Kutta_fourth-order_method
"""
function getNonStiffODE()
    ode(t, y) = (sin(t))^2 * y
    init = 1.0
    sol(t) = exp((1/2) * (t - cos(t) * sin(t)))
    return InitialValueProblem(
        "Non-stiff ODE",
        ode,
        init, # x0
        0.0, # t0
        3.0, # tf
        sol
    )
end


"""
    ODE with some steep parts.

    Source: https://tobydriscoll.net/fnc-julia/ivp/adaptive-rk.html
"""
function getDifficultODEForAdaptiveRK()
    ode(t, y) = exp(t-y*sin(y))
    init=0.0
    return InitialValueProblem(
        "IVP for Adaptive RK",
        ode,
        init,
        0.0,
        5.0,
        nothing
    )
end


"""
    An "Abel equation of the first kind" that has easy as well as steep parts in the trajectory.

    Source: https://stackoverflow.com/questions/67043427/how-to-perform-adaptive-step-size-using-runge-kutta-fourth-order-matlab
"""
function getAbelEquation()
    ode(t, y) = 3*y-y^3 + 3*cos(t)
    init=1.0
    return InitialValueProblem(
        "Abel ODE for adaptive RK",
        ode,
        init,
        0.0,
        14.0,
        nothing
    ) 
end

"""
    An ODE for the Logisic equation.

    Source: https://math.libretexts.org/Bookshelves/Calculus/Calculus_(OpenStax)/08%3A_Introduction_to_Differential_Equations/8.04%3A_The_Logistic_Equation

    Arguments:
        - `initPop`: the initial population,
        - `capacity`: the number of individuals that can be supported by the ecosystem,
        - `growthRate`: the rate at which the population grows.
"""
function getLogisticODE(;
    initPop::Float64,
    capacity::Float64,
    growthRate::Float64
)

    p0 = initPop  # initial population
    k = capacity  # max population
    r = growthRate  # growth rate

    ode(t, y) = r*y*(1-(y/k))
    exact(t) = (p0*k*exp(r*t))/((k-p0) + p0*exp(r*t))
    return InitialValueProblem(
        "Logistic ODE (p0=$(p0), k=$(k), r=$(r))",
        ode,
        p0,
        0.0,
        100.0,
        exact
    ) 
end