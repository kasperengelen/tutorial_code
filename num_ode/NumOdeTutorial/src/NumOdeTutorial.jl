
module NumOdeTutorial

include("./InitialValueProblem.jl")
include("./ODELib.jl")
include("./IVPSolver.jl")
include("./SolverRunner.jl")
include("./ForwardEuler.jl")
include("./BackwardEuler.jl")
include("./RungeKutta.jl")
include("./RungeKuttaAdaptive.jl")

"""
    main()

    Main function for the program. A single argument is expected, which can be used to select the IVP
    and algorithm to demonstrate.
"""
function main()
    if length(ARGS) != 1
        println("Error: please specify exactly one argument with the name of the example you wish to run.")
        exit(1)
    end

    exampleName = ARGS[1]

    if exampleName == "forwardEulerStable"
        NumOdeTutorial.plotAndCompareSolvers(ivp=getStableODEProblem(), 
        solvers=[ForwardEuler(1.0), ForwardEuler(0.5), ForwardEuler(0.1), ForwardEuler(0.005)], 
        filenamePrefix="forwardEulerStable",
        dimensionToPlot=1)
    elseif exampleName == "backwardEulerStable"
        NumOdeTutorial.plotAndCompareSolvers(ivp=getStableODEProblem(), 
        solvers=[BackwardEuler(1.0), BackwardEuler(0.5), BackwardEuler(0.1), BackwardEuler(0.005)], 
        filenamePrefix="backwardEulerStable",
        dimensionToPlot=1)
    
    elseif exampleName == "forwardEulerUnstable"
        NumOdeTutorial.plotAndCompareSolvers(ivp=getUnstableODEProblem(), 
        solvers=[ForwardEuler(1.0), ForwardEuler(0.5), ForwardEuler(0.1), ForwardEuler(0.005)], 
        filenamePrefix="forwardEulerUnstable",
        dimensionToPlot=1)
    elseif exampleName == "backwardEulerUnstable"
        NumOdeTutorial.plotAndCompareSolvers(ivp=getUnstableODEProblem(), 
        solvers=[BackwardEuler(1.0), BackwardEuler(0.5), BackwardEuler(0.1), BackwardEuler(0.005)], 
        filenamePrefix="backwardEulerUnstable",
        dimensionToPlot=1)
    
    elseif exampleName == "forwardEulerRiccati"
        NumOdeTutorial.plotAndCompareSolvers(ivp=getRiccatiODEProblem(), 
        solvers=[ForwardEuler(0.2), ForwardEuler(0.1), ForwardEuler(0.001), ForwardEuler(0.0002)], 
        filenamePrefix="forwardEulerRiccati",
        dimensionToPlot=1)
    elseif exampleName == "backwardEulerRiccati"
        NumOdeTutorial.plotAndCompareSolvers(ivp=getRiccatiODEProblem(), 
        solvers=[BackwardEuler(0.2), BackwardEuler(0.1), BackwardEuler(0.001), BackwardEuler(0.0002)], 
        filenamePrefix="backwardEulerRiccati",
        dimensionToPlot=1)
    
    elseif exampleName == "forwardEulerStiff"
        NumOdeTutorial.plotAndCompareSolvers(ivp=getStiffODEProblem(), 
        solvers=[ForwardEuler(0.01), ForwardEuler(0.04)], 
        filenamePrefix="forwardEulerStiff",
        dimensionToPlot=1)
    elseif exampleName == "backwardEulerStiff"
        NumOdeTutorial.plotAndCompareSolvers(ivp=getStiffODEProblem(), 
        solvers=[BackwardEuler(0.01), BackwardEuler(0.04)], 
        filenamePrefix="backwardEulerStiff",
        dimensionToPlot=1)

    elseif exampleName == "forwardEulerQuadex"
        NumOdeTutorial.plotAndCompareSolvers(ivp=getQuadexODEProblem(), 
        solvers=[ForwardEuler(0.0004), ForwardEuler(0.0008)], 
        filenamePrefix="forwardEulerQuadex",
        dimensionToPlot=1)
    elseif exampleName == "backwardEulerQuadex"
        NumOdeTutorial.plotAndCompareSolvers(ivp=getQuadexODEProblem(), 
        solvers=[BackwardEuler(0.0004), BackwardEuler(0.0008)], 
        filenamePrefix="backwardEulerQuadex",
        dimensionToPlot=1)

    elseif exampleName == "forwardEulerFlameEasy"
        NumOdeTutorial.plotAndCompareSolvers(ivp=getStiffODEProblemFlame(0.01), 
        solvers=[ForwardEuler(0.04), ForwardEuler(2.0), ForwardEuler(2.85)], 
        filenamePrefix="forwardEulerFlameEasy",
        dimensionToPlot=1)
    elseif exampleName == "backwardEulerFlameEasy"
        NumOdeTutorial.plotAndCompareSolvers(ivp=getStiffODEProblemFlame(0.01), 
        solvers=[BackwardEuler(0.04), BackwardEuler(2.0), BackwardEuler(2.85)], 
        filenamePrefix="backwardEulerFlameEasy",
        dimensionToPlot=1)
    
    elseif exampleName == "forwardEulerFlameHard"
        NumOdeTutorial.plotAndCompareSolvers(ivp=getStiffODEProblemFlame(0.0001), 
        solvers=[ForwardEuler(1.0), ForwardEuler(2.0), ForwardEuler(4.0)], 
        filenamePrefix="forwardEulerFlameHard",
        dimensionToPlot=1)
    elseif exampleName == "backwardEulerFlameHard"
        NumOdeTutorial.plotAndCompareSolvers(ivp=getStiffODEProblemFlame(0.0001), 
        solvers=[BackwardEuler(20.0), BackwardEuler(40.0), BackwardEuler(200.0), BackwardEuler(285.7)], 
        filenamePrefix="backwardEulerFlameHard",
        dimensionToPlot=1)

    elseif exampleName == "compareForwardBackwardEulerSimpleStiff"
        NumOdeTutorial.plotAndCompareSolvers(ivp=getStiffODEProblem(), 
        solvers=[BackwardEuler(0.04), ForwardEuler(0.04)], 
        filenamePrefix="compareForwardBackwardEulerSimpleStiff",
        dimensionToPlot=1)

    elseif exampleName == "compareRK3"
        NumOdeTutorial.plotAndCompareSolvers(ivp=getNonStiffODE(), 
        solvers=[ForwardEuler(0.5), RK2Midpoint(0.5), RK3Kutta(0.5), ForwardEuler(0.5/3)], 
        filenamePrefix="compareRK3",
        dimensionToPlot=1)

    elseif exampleName == "compareRK4"
        NumOdeTutorial.plotAndCompareSolvers(ivp=getNonStiffODE(), 
        solvers=[ForwardEuler(0.5/4), RK4Kutta(0.1), RK4Kutta(0.5)], 
        filenamePrefix="compareRK4",
        dimensionToPlot=1)

    elseif exampleName == "compareRKCosineStable"
        NumOdeTutorial.plotAndCompareSolvers(ivp=getStableODEProblem(), 
        solvers=[ForwardEuler(0.5), ForwardEuler(0.1), RK2Midpoint(0.5), RK3Kutta(0.5), RK4Kutta(0.5)], 
        filenamePrefix="compareRKCosineStable",
        dimensionToPlot=1)

    elseif exampleName == "compareRKCosineUnstable"
        NumOdeTutorial.plotAndCompareSolvers(ivp=getUnstableODEProblem(), 
        solvers=[ForwardEuler(0.5), ForwardEuler(0.1), RK2Midpoint(0.5), RK3Kutta(0.5), RK4Kutta(0.5)], 
        filenamePrefix="compareRKCosineStable",
        dimensionToPlot=1)
    
    elseif exampleName == "rungeKuttaAdaptiveExp"
        NumOdeTutorial.solveAndPlotSystem(
            ivp=getDifficultODEForAdaptiveRK(), 
            solver=RKF45(
                atol=1e-5, 
                initStepSize=0.5,
                minStepSize=0.00001,
                maxStepSize=0.5,
                minStepScale=0.1,
                maxStepScale=4.0,
            ), 
            filenamePrefix="rungeKuttaAdaptiveExp")
    
    elseif exampleName == "rungeKuttaAdaptiveAbel"
        NumOdeTutorial.solveAndPlotSystem(
            ivp=getAbelEquation(), 
            solver=RKF45(
                atol=5e-4, 
                initStepSize=5e-2,
                minStepSize=0.00001,
                maxStepSize=1.0,
                minStepScale=0.1,
                maxStepScale=4.0,
            ), 
            filenamePrefix="rungeKuttaAdaptiveAbel")

    elseif exampleName == "rungeKuttaAdaptiveLogistic"
        NumOdeTutorial.solveAndPlotSystem(
            ivp=getLogisticODE(
                initPop=1.0,
                capacity=60.0,
                growthRate=0.1
            ), 
            solver=RKF45(
                atol=5e-4, 
                initStepSize=1.0,#5e-2,
                minStepSize=0.00001,
                maxStepSize=5.0,
                minStepScale=0.1,
                maxStepScale=4.0,
            ), 
            filenamePrefix="rungeKuttaAdaptiveLogistic")

    elseif exampleName == "rungeKuttaAdaptiveCosineStable"
        NumOdeTutorial.solveAndPlotSystem(
            ivp=getStableODEProblem(), 
            solver=RKF45(
                atol=1e-5, 
                initStepSize=5e-2,
                minStepSize=0.00001,
                maxStepSize=1.0,
                minStepScale=0.1,
                maxStepScale=4.0,
            ), 
        filenamePrefix="rungeKuttaAdaptiveCosineStable")

    elseif exampleName == "rungeKuttaAdaptiveLotkaVolterraA"
        NumOdeTutorial.solveAndPlotSystem(
            ivp=getLotkaVolterraODE(
                # wikipedia: Lotka-Volterra
                alpha=1.1,
                beta=0.4,
                gamma=0.4,
                delta=0.1,
                initPreyDensity=10.0,
                initPredatorDensity=10.0
            ), 
            solver=RKF45(
                atol=1e-5, 
                initStepSize=5e-2,
                minStepSize=0.00001,
                maxStepSize=1.0,
                minStepScale=0.1,
                maxStepScale=4.0,
            ), 
        filenamePrefix="rungeKuttaAdaptiveLotkaVolterraA")
    elseif exampleName == "rungeKuttaAdaptiveLotkaVolterraB"
        NumOdeTutorial.solveAndPlotSystem(
            ivp=getLotkaVolterraODE(
                # https://mbe.modelica.university/behavior/equations/population/
                alpha=0.1,
                beta=0.02,
                gamma=0.4,
                delta=0.02,
                initPreyDensity=10.0,
                initPredatorDensity=10.0
            ), 
            solver=RKF45(
                atol=1e-5, 
                initStepSize=5e-2,
                minStepSize=0.00001,
                maxStepSize=1.0,
                minStepScale=0.1,
                maxStepScale=4.0,
            ), 
        filenamePrefix="rungeKuttaAdaptiveLotkaVolterraB")
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
