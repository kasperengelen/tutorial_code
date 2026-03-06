

const FunctionValue = Vector{Float64}

"""
    Represents the solution to an initial value problem:
        - a vector of time values at which the IVP solution has been approximated,
        - a trajectory of vectors, where each vector is the vector of function values at that specific time-step.
"""
struct IVPSolution
    timeValues::Vector{Float64}
    trajectory::Vector{FunctionValue}  # trajectory of function values
end


"""
    Represents a solver for initial value problems, including:
        - a solver function InitialValueProblem -> IVPSolution,
        - a human-readable name that can be used for reporting and plotting.
"""
struct IVPSolver
    solver::Function
    name::String
end
