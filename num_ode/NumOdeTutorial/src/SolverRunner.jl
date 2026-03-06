
using Plots

"""
    transformTrajectory(trajectory::Vector{Vector{Float64}})::Vector{Vector{Float64}}

    This takes a trajectory where each element is a vector. Each such vector has one entry for
    every dimension of the ODE.

    The return value is a vector of trajectories. The vector has one element for each dimension of the ODE,
    and each trajectory is a sequence of floats. Each float is the value of that specific dimension at the
    respective time-step.
"""
function transformTrajectory(trajectory::Vector{Vector{Float64}})::Vector{Vector{Float64}}
    numDimensions = length(trajectory[1])
    retval = [[] for _ in 1:numDimensions]

    for stepIdx in 1:length(trajectory)
        step = trajectory[stepIdx]
        for dimension in 1:numDimensions
            push!(retval[dimension], step[dimension])
        end
    end

    return retval
end



"""
    Solve the given IVP using the different solvers and plot the indicated dimension.
"""
function plotAndCompareSolvers(;ivp::InitialValueProblem, solvers::Array{IVPSolver}, dimensionToPlot::Int64, filenamePrefix::String)
    # plot exact solution
    Plots.plot()  # this creates a new empty plot
    if ivp.exactSolution !== nothing
        # if an exact solution exists, we plot it
        exactSolutionInDimension(t) = ivp.exactSolution(t)[dimensionToPlot]
        Plots.plot!(exactSolutionInDimension, ivp.initialTime, ivp.endTime, label="Exact solution", dpi=500)
    end

    # run each solver
    solverSolutions::Vector{IVPSolution} = [solver.solver(ivp) for solver in solvers]

    # plot for each solver
    Plots.plot()  # this creates a new empty plot
    for (idx, solver) in enumerate(solvers)
        solverSolution = solverSolutions[idx]
        timeValues = solverSolution.timeValues
        trajectories = transformTrajectory(solverSolution.trajectory)
        trajectory = trajectories[dimensionToPlot]

        if length(trajectory) <= 100
            Plots.plot!(timeValues, trajectory, markershape = :auto, label=solver.name, dpi=500, title="$(ivp.name): trajectories dim=$(dimensionToPlot)")
        else
            # plot no markers if there are too many points
            Plots.plot!(timeValues, trajectory, markershape = :none, label=solver.name, dpi=500, title="$(ivp.name): trajectories dim=$(dimensionToPlot)")
        end
    end
    savefig("$(filenamePrefix)_dim$(dimensionToPlot)_traj.png")

    Plots.plot()  # this creates a new empty plot
    for (idx, solver) in enumerate(solvers)
        solverSolution = solverSolutions[idx]
        timeValues = solverSolution.timeValues
        
        stepSizes = diff(timeValues)
        Plots.plot!(timeValues[1:end-1], stepSizes, markershape = :none, yaxis=:log10, label=solver.name, dpi=500, title="$(ivp.name): step-sizes")
    end
    Plots.savefig("$(filenamePrefix)_dim$(dimensionToPlot)_steps.png")
end

"""
    Plot all the dimensions of a system using one single solver method.
"""
function solveAndPlotSystem(;ivp::InitialValueProblem, solver::IVPSolver, filenamePrefix::String)

    solution::IVPSolution = solver.solver(ivp)
    trajectories = transformTrajectory(solution.trajectory)
    timeValues = solution.timeValues
    numDimensions = length(trajectories)

     # plot exact solution
    for dimension in 1:numDimensions
        # compute exact solution in this specific dimension
        exactSolutionInDimension(t) = ivp.exactSolution(t)[dimension]

        if ivp.exactSolution !== nothing
            # if an exact solution exists, we plot it
            Plots.plot!(exactSolutionInDimension, ivp.initialTime, ivp.endTime, label="Exact solution", dpi=500)
        end
    end

    # plot the trajectory for each dimension
    for dimension in 1:numDimensions
        dimensionLabel = ivp.labels[dimension]
        trajectory = trajectories[dimension]
        if length(trajectory) <= 100
            Plots.plot!(timeValues, trajectory, markershape = :auto, label=dimensionLabel, dpi=500, title="$(ivp.name): trajectories")
        else
            # plot no markers if there are too many points
            Plots.plot!(timeValues, trajectory, markershape = :none, label=dimensionLabel, dpi=500, title="$(ivp.name): trajectories")
        end
    savefig("$(filenamePrefix)_traj.png")
    end

    # plot the step sizes. These are the same for all dimensions
    Plots.plot()  # this creates a new empty plot

        
    stepSizes = diff(timeValues)
    Plots.plot!(timeValues[1:end-1], stepSizes, label="step size", markershape = :none, yaxis=:log10, dpi=500, title="$(ivp.name): step-sizes")
    Plots.savefig("$(filenamePrefix)_steps.png")
end


