
using CairoMakie
using LinearAlgebra

"""
    Function to create a 2D phase plot for an ODE.

    Arguments:
    - `ivp`: the initial value problem whose ODE and solution will be plotted,
    - `solver`: the solver to obtain the solution of the IVP,
    - `dim1`: the index of the first dimension (x-axis),
    - `dim2`: the index of the second dimension (y-axis),
    - `filenamePrefix`: prefix of all produces PNG files,
    - `timeValue`: the time-value at which the ODE will be plotted,
    - `stateValues`: a function that maps a vector [dim 1 value, dim 2 value] onto the full state vector,
    - `dim1Range`: a tuple (min, max) indicating the range of the first dimension,
    - `dim2Range`: a tuple (min, max) indicating the range of the second dimension.

    Note: the `stateValues` function is used internally to map 2D points from the phase portrait onto state vectors that can be used
    to compute the values of the ODE `f(t, y)`. For that we need the full state vector `y``.
"""
function parametricStreamPlot(;
    ivp::InitialValueProblem, 
    solver::Union{IVPSolver, Nothing}, 
    dim1::Int64,
    dim2::Int64, 
    filenamePrefix::String,
    timeValue::Float64,
    stateValues::Function,
    dim1Range::Tuple{Float64, Float64},
    dim2Range::Tuple{Float64, Float64}
)

    # PLOT ODE
    f1(t, y) = ivp.diffEq(t, y)[dim1]
    f2(t, y) = ivp.diffEq(t, y)[dim2]

    f(x) = Point2f(
        f1(timeValue, stateValues(x)),
        f2(timeValue, stateValues(x))
    )

    dim1Min = dim1Range[1]
    dim1Max = dim1Range[2]
    dim2Min = dim2Range[1]
    dim2Max = dim2Range[2]

    fig = Figure(size = (500, 500))   # note: `size`, not resolution
    ax = Axis(fig[1, 1])

    streamplot!(
        ax,
        f, 
        dim1Min..dim1Max, 
        dim2Min..dim2Max, 
        arrow_size = 9, 
        linewidth=1, 
        colormap = :diverging_rainbow_bgymr_45_85_c67_n256
    )

    # horizontal line y = 0
    hlines!(ax, 0; color = :black, linewidth = 1)

    # vertical line x = 0
    vlines!(ax, 0; color = :black, linewidth = 1)

    # ADD SOLUTION
    if solver !== nothing
        solution::IVPSolution = solver.solver(ivp)
        trajectories = transformTrajectory(solution.trajectory)

        traj1 = trajectories[dim1]
        traj2 = trajectories[dim2]

        lines!(
            ax,
            traj1,
            traj2,
            color = :red,
            linewidth = 2,
            label = "trajectory"
        )
    end

    # set axis labels of the figure
    traj1Label = ivp.labels[dim1]
    traj2Label = ivp.labels[dim2]
    ax.xlabel = traj1Label
    ax.ylabel = traj2Label

    save("$(filenamePrefix)_streamLines.png", fig; px_per_unit = 3)
end
