
using Plots

include("./ODELib.jl")
include("./IVPSolver.jl")

"""
    solveAndPlot(;ivp::InitialValueProblem, solvers::Array{IVPSolver}, filenamePrefix::String)

    Solve the specified IVP using each of the specified IVP solvers and plot the resulting trajectories. 
    Each trajectory will be labeled with the label of the respective solver.
    
    All filenames of the plots will be named with the specified filename prefix. There will be a "traj" plot
    with the simulated trajectories, and a "steps" plot with the step-sizes.
"""
function solveAndPlot(;ivp::InitialValueProblem, solvers::Array{IVPSolver}, filenamePrefix::String)

    # run each solver
    trajectories = [solver.solver(ivp) for solver in solvers]

    # plot exact solution
    if ivp.exactSolution !== nothing
        # if an exact solution exists, we plot it
        plot!(ivp.exactSolution, ivp.initialTime, ivp.endTime, label="Exact solution", dpi=500)
    end

    # plot for each solver
    for (idx, solver) in enumerate(solvers)
        trajectory = trajectories[idx]

        if length(trajectory) <= 100
            plot!(trajectory, markershape = :auto, label=solver.name, dpi=500, title="$(ivp.name): trajectories")
        else
            # plot no markers if there are too many points
            plot!(trajectory, markershape = :none, label=solver.name, dpi=500, title="$(ivp.name): trajectories")
        end
    end
    savefig("$(filenamePrefix)_traj.png")

    plot()  # this creates a new empty plot
    for (idx, solver) in enumerate(solvers)
        trajectory = trajectories[idx]
        timeValues = [step[1] for step in trajectory]
        
        stepSizes = diff(timeValues)
        plot!(timeValues[1:end-1], stepSizes, markershape = :none, yaxis=:log10, label=solver.name, dpi=500, title="$(ivp.name): step-sizes")
    end
    savefig("$(filenamePrefix)_steps.png")
end
