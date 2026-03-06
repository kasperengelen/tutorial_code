
module NumOdeTutorial

include("../InitialValueProblem.jl")
include("../ODELib.jl")
include("../IVPSolver.jl")
include("../RungeKutta.jl")
include("../RungeKuttaAdaptive.jl")
include("../SolverRunner.jl")
include("../PhasePlot2D.jl")

"""
    main()

    Entry point for running experiments related to the Romeo and Juliet article. This provides several scenarios for which
    the phase portrait and some simulations are plotted.

"""
function main()
    if length(ARGS) != 1
        println("Error: please specify exactly one argument with the name of the example you wish to run.")
        exit(1)
    end

    exampleName = ARGS[1]

    # a = R to R
    # b = J to R
    # c = R to J
    # d = J to J

    fixedValues(x) = [x[1], x[2]]
    if exampleName == "mutualAttractionNoLimit"
        a = 0.0
        b = 0.5
        c = 0.5
        d = 0.0

        ivp=getRomeoJulietODE(
            a = a,
            b = b,
            c = c,
            d = d,
            initR = 4.0,
            initJ = 2.0,
            finalTime = 10.0
        )

        NumOdeTutorial.parametricStreamPlot(
            ivp=ivp,
            solver=nothing,
            dim1=1,
            dim2=2,
            filenamePrefix="mutualAttractionNoLimit_a=$(a)_b=$(b)_c=$(c)_d=$(d)",
            timeValue=0.0,
            stateValues=fixedValues,
            dim1Range=(-10.0, 10.0),
            dim2Range=(-10.0, 10.0)
        )

        NumOdeTutorial.solveAndPlotSystem(
            ivp=ivp, 
            solver=RK4Kutta(0.0001),
            filenamePrefix="mutualAttractionNoLimit_a=$(a)_b=$(b)_c=$(c)_d=$(d)")

    elseif exampleName == "dampeningEquilibrium"

        a = -2.0
        b = 2.0
        c = 2.0
        d = -2.0

        # Case 2: "secure" damping effect
        ivp=getRomeoJulietODE(
            a = a,
            b = b,
            c = c,
            d = d,
            initR = 0.0,
            initJ = 0.0,
            finalTime = 2.0
        )

        NumOdeTutorial.parametricStreamPlot(
            ivp=ivp,
            solver=nothing,
            dim1=1,
            dim2=2,
            filenamePrefix="dampeningEquilibrium_a=$(a)_b=$(b)_c=$(c)_d=$(d)",
            timeValue=0.0,
            stateValues=fixedValues,
            dim1Range=(-10.0, 10.0),
            dim2Range=(-10.0, 10.0)
        )

    elseif exampleName == "lossOfInterest"

        a = -4.0
        b = 1.0
        c = 1.0
        d = -4.0

        initR = 4.0
        initJ = 7.0

        ivp=getRomeoJulietODE(
            a=a,
            b=b,
            c=c,
            d=d,
            initR=initR,
            initJ=initJ,
            finalTime = 2.0
        )

        NumOdeTutorial.parametricStreamPlot(
            ivp=ivp,
            solver=nothing,
            dim1=1,
            dim2=2,
            filenamePrefix="lossOfInterest_a=$(a)_b=$(b)_c=$(c)_d=$(d)",
            timeValue=0.0,
            stateValues=fixedValues,
            dim1Range=(-10.0, 10.0),
            dim2Range=(-10.0, 10.0)
        )

        NumOdeTutorial.solveAndPlotSystem(
            ivp=ivp, 
            solver=RK4Kutta(0.0001),
            filenamePrefix="lossOfInterest_a=$(a)_b=$(b)_c=$(c)_d=$(d)")

    elseif exampleName == "attractionRepulsionDecreasing"

        a = -0.5  # R influences R
        b = -2.0  # R influences J
        c =  2.0  # J influences R
        d = -0.5  # J influences J

        initR = 2.0
        initJ = 3.0

        ivp=getRomeoJulietODE(
            a=a,
            b=b,
            c=c,
            d=d,
            initR=initR,
            initJ=initJ,
            finalTime = 10.0
        )

        NumOdeTutorial.parametricStreamPlot(
            ivp=ivp,
            solver=nothing,
            dim1=1,
            dim2=2,
            filenamePrefix="attractionRepulsionDecreasing_a=$(a)_b=$(b)_c=$(c)_d=$(d)",
            timeValue=0.0,
            stateValues=fixedValues,
            dim1Range=(-10.0, 10.0),
            dim2Range=(-10.0, 10.0)
        )

        NumOdeTutorial.solveAndPlotSystem(
            ivp=ivp, 
            solver=RK4Kutta(0.0001),
            filenamePrefix="attractionRepulsionDecreasing_a=$(a)_b=$(b)_c=$(c)_d=$(d)"
        )
    elseif exampleName == "attractionRepulsionIncreasing"

        # Case 3: attraction-repulsion
        a =  0.1  # R influences R
        b =  2.0  # R influences J
        c = -2.0  # J influences R
        d =  0.1  # J influences J

        initR = 2.0
        initJ = 0.0

        ivp=getRomeoJulietODE(
            a=a,
            b=b,
            c=c,
            d=d,
            initR=initR,
            initJ=initJ,
            finalTime = 15.0
        )

        NumOdeTutorial.parametricStreamPlot(
            ivp=ivp,
            solver=nothing,
            dim1=1,
            dim2=2,
            filenamePrefix="attractionRepulsionIncreasing_a=$(a)_b=$(b)_c=$(c)_d=$(d)",
            timeValue=0.0,
            stateValues=fixedValues,
            dim1Range=(-10.0, 10.0),
            dim2Range=(-10.0, 10.0)
        )

        NumOdeTutorial.solveAndPlotSystem(
            ivp=ivp, 
            solver=RK4Kutta(0.0001),
            filenamePrefix="attractionRepulsionIncreasing_a=$(a)_b=$(b)_c=$(c)_d=$(d)"
        )
    else
        println("Invalid example name '$(exampleName)'.")
        exit(1)
    end

end

# run the program
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end

end
