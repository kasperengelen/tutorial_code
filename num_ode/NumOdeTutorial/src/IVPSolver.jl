

"""
    Represents the solution to an initial value problem:
        - a vector of time values at which the IVP solution has been approximated,
        - a trajectory of vectors, where each vector is the vector of function values at that specific time-step.
"""
struct IVPSolution
    timeValues::Vector{Float64}
    trajectory::Vector{Vector{Float64}}  # trajectory of vectors
end


"""
    Represents a solver for initial value problems, including:
        - a solver function InitialValueProblem -> IVPSolution,
        - a human-readable name that can be used for reporting and plotting.

    Note that the produced trajectory is a Vector{Tuple{Float64,Vector{Float64}}}, which encodes
    a sequence of tuples (t, y) where y is a vector of floats (one float per dimension of the ODE system).
"""
struct IVPSolver
    solver::Function
    name::String
end
