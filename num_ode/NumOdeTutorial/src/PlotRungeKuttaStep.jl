
include("./InitialValueProblem.jl")
include("./ODELib.jl")

using CairoMakie
using LinearAlgebra


"""
    Plot one single step of the Runge-Kutta algorithm.

    This will plot a vector field in the background. The points at which RK samples the ODE are plotted,
    together with the derivatives computed at those points. The initial and next function values approximated
    by RK will also be visible. Finally, if present, the exact solution will also be plotted.

    Arguments:
        - a: The RK coefficient matrix,
        - b: The RK weights,
        - c: The RK nodes,
        - numStages: the number of RK stages,
        - ode: the ODE f(t,y)
        - exactSolution: the exact solution y(t),
        - currentTime: starting time of this RK step,
        - currentVal: starting value of this RK step,
        - stepSize: the stepSize,
        - tMin: minimum t value for plotting,
        - tMax: maximum t value for plotting,
        - yMin: minimum y value for plotting,
        - yMax: maximum y value for plotting,
        - filename: the filename of the resulting plot.
"""
function plotRungeKuttaStep(;
        a::Matrix{Float64}, b::Vector{Float64}, c::Vector{Float64}, numStages::Int64, 
        ode::Function,  # f(t,y)
        exactSolution::Function, # y(t)
        currentTime::Float64, currentVal::Vector{Float64}, stepSize::Float64,
        tMin::Float64, tMax::Float64,
        yMin::Float64, yMax::Float64,
        filename::String,
        dimensionToPlot::Int64
    )

    # plot the vector field
    f_t(t, y) = 1
    f_y(t, y) = ode(t, y)[dimensionToPlot]
    f(x) = Point2f(f_t(x[1], x[2]), f_y(x[1], x[2]))
    fig, ax, _ = streamplot(f, tMin..tMax, yMin..yMax, arrow_size = 1, linewidth = 0.5, colormap=([:black]))

    # plot the exact solution to the ode
    if exactSolution !== nothing
        exactSolInDimension(t) = exactSolution(t)[dimensionToPlot]
        lines!(fig[1, 1], tMin..tMax, exactSolInDimension, color = :red)
    end

    # initialise k1
    k_vals::Vector{Vector{Float64}} = [ode(currentTime, currentVal)]

    sample_points_to_plot_t = []
    sample_points_to_plot_y = []

    # iterate
    for s in 2:numStages
        # compute time value at which we sample the ODE
        time_val = currentTime + c[s] * stepSize

        # approximate function value at which we sample the ODE
        a_vec = a[s, 1:s-1]
        if !iszero(a[s, s:end])
            throw(ArgumentError("Error: this function only supports explicit 
                RK methods, but an implicit coefficient matrix was passed."))
        end

        if length(a_vec) != length(k_vals)
            throw(DimensionMismatch("Error: `a_vec` and `k_vals` must have the same number of elements!"))
        end

        func_val_approx = currentVal + stepSize * sum(a_vec .* k_vals)

        # evaluate ODE
        k_val = ode(time_val, func_val_approx)  

        # plot point at (time_val, func_val_approx[dimensionToPlot])
        push!(sample_points_to_plot_t, time_val)
        push!(sample_points_to_plot_y, func_val_approx[dimensionToPlot])

        k_val_in_dim = k_val[dimensionToPlot]

        # plot slope around the point that visualises the approximate derivative
        line_points_t = [time_val - 0.1*stepSize, time_val + 0.1*stepSize]
        line_points_y = [func_val_approx[dimensionToPlot] - 0.1*stepSize*k_val_in_dim, func_val_approx[dimensionToPlot] + 0.1*stepSize*k_val_in_dim]
        lines!(line_points_t, line_points_y, label = "k$(s)")

        push!(k_vals, k_val)
    end

    # plot the points at which the ODE was sampled  
    scatter!(sample_points_to_plot_t, sample_points_to_plot_y)

    # plot the initial point and the next point determined by the Runge kutta algorithm
    # Note that these are all vectors. As such, we always take the dimension given by `dimensionToPlot`.
    scatter!([currentTime], [currentVal[dimensionToPlot]], 
                marker=:diamond, markersize = 15, color=:red, label="Initial")

    RK_value::Float64 = (currentVal + stepSize * sum(b .* k_vals))[dimensionToPlot]
    scatter!([currentTime + stepSize], [RK_value], 
                marker=:diamond, markersize = 15, color=:black, label="RK$(numStages)")

    # FE = only use 1st k value
    FE_value::Float64 = (currentVal + stepSize * k_vals[1])[dimensionToPlot]
    scatter!([currentTime + stepSize], [FE_value], 
                marker=:diamond, markersize = 15, color=:green, label="FE")

    # store
    axislegend(ax; position = :rb, labelsize = 15)
    save(filename, fig)
end


"""
    Plot figure for the article.
"""
function plotExampleNonStiff()
    ivp = getNonStiffODE()
    currentTime=1.0
    currentVal::Vector{Float64} = ivp.exactSolution(currentTime)
    plotRungeKuttaStep(        
        a=[0 0 0 0; 1/2 0 0 0; 0 1/2 0 0; 0 0 1 0],
        b=[1/6, 1/3, 1/3, 1/6],
        c=[0, 1/2, 1/2, 1],
        currentTime=currentTime,
        currentVal=currentVal,
        tMin = 0.9,
        tMax = 2.1,
        yMin = 0.0,
        yMax = 4.0,
        numStages=4,
        stepSize=1.0,
        ode=ivp.diffEq,
        exactSolution=ivp.exactSolution,
        filename="rk4_kutta_nonstiff.png",
        dimensionToPlot=1
    )
end


"""
    Plot figure for the article.
"""
function plotExampleCosineStable()
    ivp=getStableODEProblem()
    currentTime=2.5
    currentVal::Vector{Float64} = ivp.exactSolution(currentTime)
    plotRungeKuttaStep(        
        a=[0 0 0 0; 1/2 0 0 0; 0 1/2 0 0; 0 0 1 0],
        b=[1/6, 1/3, 1/3, 1/6],
        c=[0, 1/2, 1/2, 1],
        currentTime=currentTime,
        currentVal=currentVal,
        tMin = 2.4,
        tMax = 4.6,
        yMin = -2.5,
        yMax = 0.5,
        numStages=4,
        stepSize=1.5,
        ode=ivp.diffEq,
        exactSolution=ivp.exactSolution,
        filename="rk4_kutta_cos.png",
        dimensionToPlot=1
    )
end

# run the program
if abspath(PROGRAM_FILE) == @__FILE__
    plotExampleNonStiff()
    plotExampleCosineStable()
end
