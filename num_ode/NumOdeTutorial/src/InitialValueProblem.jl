
"""
    Represents an initial value problem, including:
        - the human-readable name of the ODE,
        - the ODE f(t,y),
        - the initial value,
        - the initial time, associated with the initial value,
        - the end time, upon which the solver should stop,
        - optionally, the exact solution to the IVP,
        - a vector of strings, where each string labels a dimension of the ODE.

    The `initialValue`, and `exactSolution` arguments are of type Vector. These vectors
    have one entry for each dimension of the ODE system. The ODE `diffEq` maps a time value (Float64)
    and state value (Vector{Float64}) onto a vector of derivatives at that point (Vector{Float64}).
    
    It is thus important to note that `diffEq` is not a vector of functions! Similarly, 
    the `exactSolution` maps a time `t` onto a vector of function values.
"""
struct InitialValueProblem
    name::String
    diffEq::Function
    initialValue::Vector{Float64}
    initialTime::Float64
    endTime::Float64
    exactSolution::Union{Function, Nothing}
    labels::Vector{String}
end
