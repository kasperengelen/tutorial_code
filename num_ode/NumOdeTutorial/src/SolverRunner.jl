
using Plots

include("./ODELib.jl")
include("./IVPSolver.jl")

"""
    solveAndPlotGeneric(;ivp::InitialValueProblem, solvers::Array{IVPSolver}, filename::String)

    Solve the specified IVP using each of the specified IVP solvers and plot the resulting trajectories. 
    Each trajectory will be labeled with the label specified by the respective solver.
    The resulting plot will be stored at the specified filename.
"""
function solveAndPlot(;ivp::InitialValueProblem, solvers::Array{IVPSolver}, filename::String)
    # plot for each solver
    for solver in solvers
        functionValues = solver.solver(ivp)

        if length(functionValues) <= 100
            plot!(functionValues, markershape = :auto, label=solver.name, dpi=500, title=ivp.name)
        else
            # plot different markers if there are too many points
            plot!(functionValues, markershape = :none, label=solver.name, dpi=500, title=ivp.name)
        end
    end

    if ivp.exactSolution !== nothing
        # if an exact solution exists, we plot it
        plot!(ivp.exactSolution, ivp.initialTime, ivp.endTime, label="Exact solution", dpi=500)
    end
    savefig(filename)
end
