
"""
    Represents a solver for initial value problems, including:
        - a solver function that can be called on an IVP and produces a trajectory,
        - a name that can be used for reporting and plotting.
"""
struct IVPSolver
    solver::Function  # function that accepts a single argument of the type InitialValueProblem
    name::String
end
