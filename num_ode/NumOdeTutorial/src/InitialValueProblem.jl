
"""
    Represents an initial value problem, including:
        - the human-readable name of the ODE,
        - the ODE f(t,y),
        - the initial value,
        - the initial time, associated with the initial value,
        - the end time, upon which the solver should stop,
        - optionally, the exact solution to the IVP.
"""
struct InitialValueProblem
    name::String
    diffEq::Function
    initialValue::Float64
    initialTime::Float64
    endTime::Float64
    exactSolution::Union{Function, Nothing}
end
