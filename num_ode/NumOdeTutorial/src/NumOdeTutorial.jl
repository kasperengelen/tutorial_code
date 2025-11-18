
module NumOdeTutorial

include("./ODELib.jl")
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
        NumOdeTutorial.solveAndPlot(ivp=getStableODEProblem(), 
        solvers=[ForwardEuler(1.0), ForwardEuler(0.5), ForwardEuler(0.1), ForwardEuler(0.005)], 
        filenamePrefix="forwardEulerStable")
    elseif exampleName == "backwardEulerStable"
        NumOdeTutorial.solveAndPlot(ivp=getStableODEProblem(), 
        solvers=[BackwardEuler(1.0), BackwardEuler(0.5), BackwardEuler(0.1), BackwardEuler(0.005)], 
        filenamePrefix="backwardEulerStable")
    
    elseif exampleName == "forwardEulerUnstable"
        NumOdeTutorial.solveAndPlot(ivp=getUnstableODEProblem(), 
        solvers=[ForwardEuler(1.0), ForwardEuler(0.5), ForwardEuler(0.1), ForwardEuler(0.005)], 
        filenamePrefix="forwardEulerUnstable")
    elseif exampleName == "backwardEulerUnstable"
        NumOdeTutorial.solveAndPlot(ivp=getUnstableODEProblem(), 
        solvers=[BackwardEuler(1.0), BackwardEuler(0.5), BackwardEuler(0.1), BackwardEuler(0.005)], 
        filenamePrefix="backwardEulerUnstable")
    
    elseif exampleName == "forwardEulerRiccati"
        NumOdeTutorial.solveAndPlot(ivp=getRiccatiODEProblem(), 
        solvers=[ForwardEuler(0.2), ForwardEuler(0.1), ForwardEuler(0.001), ForwardEuler(0.0002)], 
        filenamePrefix="forwardEulerRiccati")
    elseif exampleName == "backwardEulerRiccati"
        NumOdeTutorial.solveAndPlot(ivp=getRiccatiODEProblem(), 
        solvers=[BackwardEuler(0.2), BackwardEuler(0.1), BackwardEuler(0.001), BackwardEuler(0.0002)], 
        filenamePrefix="backwardEulerRiccati")
    
    elseif exampleName == "forwardEulerStiff"
        NumOdeTutorial.solveAndPlot(ivp=getStiffODEProblem(), 
        solvers=[ForwardEuler(0.01), ForwardEuler(0.04)], 
        filenamePrefix="forwardEulerStiff")
    elseif exampleName == "backwardEulerStiff"
        NumOdeTutorial.solveAndPlot(ivp=getStiffODEProblem(), 
        solvers=[BackwardEuler(0.01), BackwardEuler(0.04)], 
        filenamePrefix="backwardEulerStiff")

    elseif exampleName == "forwardEulerQuadex"
        NumOdeTutorial.solveAndPlot(ivp=getQuadexODEProblem(), 
        solvers=[ForwardEuler(0.0004), ForwardEuler(0.0008)], 
        filenamePrefix="forwardEulerQuadex")
    elseif exampleName == "backwardEulerQuadex"
        NumOdeTutorial.solveAndPlot(ivp=getQuadexODEProblem(), 
        solvers=[BackwardEuler(0.0004), BackwardEuler(0.0008)], 
        filenamePrefix="backwardEulerQuadex")

    elseif exampleName == "forwardEulerFlameEasy"
        NumOdeTutorial.solveAndPlot(ivp=getStiffODEProblemFlame(0.01), 
        solvers=[ForwardEuler(0.04), ForwardEuler(2.0), ForwardEuler(2.85)], 
        filenamePrefix="forwardEulerFlameEasy")
    elseif exampleName == "backwardEulerFlameEasy"
        NumOdeTutorial.solveAndPlot(ivp=getStiffODEProblemFlame(0.01), 
        solvers=[BackwardEuler(0.04), BackwardEuler(2.0), BackwardEuler(2.85)], 
        filenamePrefix="backwardEulerFlameEasy")
    
    elseif exampleName == "forwardEulerFlameHard"
        NumOdeTutorial.solveAndPlot(ivp=getStiffODEProblemFlame(0.0001), 
        solvers=[ForwardEuler(1.0), ForwardEuler(2.0), ForwardEuler(4.0)], 
        filenamePrefix="forwardEulerFlameHard")
    elseif exampleName == "backwardEulerFlameHard"
        NumOdeTutorial.solveAndPlot(ivp=getStiffODEProblemFlame(0.0001), 
        solvers=[BackwardEuler(20.0), BackwardEuler(40.0), BackwardEuler(200.0), BackwardEuler(285.7)], 
        filenamePrefix="backwardEulerFlameHard")

    elseif exampleName == "compareForwardBackwardEulerSimpleStiff"
        NumOdeTutorial.solveAndPlot(ivp=getStiffODEProblem(), 
        solvers=[BackwardEuler(0.04), ForwardEuler(0.04)], 
        filenamePrefix="compareForwardBackwardEulerSimpleStiff")

    elseif exampleName == "compareRK3"
        NumOdeTutorial.solveAndPlot(ivp=getNonStiffODE(), 
        solvers=[ForwardEuler(0.5), RK2Midpoint(0.5), RK3Kutta(0.5), ForwardEuler(0.5/3)], 
        filenamePrefix="compareRK3")

    elseif exampleName == "compareRK4"
        NumOdeTutorial.solveAndPlot(ivp=getNonStiffODE(), 
        solvers=[ForwardEuler(0.5/4), RK4Kutta(0.1), RK4Kutta(0.5)], 
        filenamePrefix="compareRK4")

    elseif exampleName == "compareRKCosineStable"
        NumOdeTutorial.solveAndPlot(ivp=getStableODEProblem(), 
        solvers=[ForwardEuler(0.5), ForwardEuler(0.1), RK2Midpoint(0.5), RK3Kutta(0.5), RK4Kutta(0.5)], 
        filenamePrefix="compareRKCosineStable")

    elseif exampleName == "compareRKCosineUnstable"
        NumOdeTutorial.solveAndPlot(ivp=getUnstableODEProblem(), 
        solvers=[ForwardEuler(0.5), ForwardEuler(0.1), RK2Midpoint(0.5), RK3Kutta(0.5), RK4Kutta(0.5)], 
        filenamePrefix="compareRKCosineStable")
    
    elseif exampleName == "rungeKuttaAdaptiveExp"
        NumOdeTutorial.solveAndPlot(
            ivp=getDifficultODEForAdaptiveRK(), 
            solvers=[RKF45(
                atol=1e-5, 
                initStepSize=0.5,
                minStepSize=0.00001,
                maxStepSize=0.5,
                minStepScale=0.1,
                maxStepScale=4.0,
            )], 
            filenamePrefix="rungeKuttaAdaptiveExp")
    
    elseif exampleName == "rungeKuttaAdaptiveAbel"
        NumOdeTutorial.solveAndPlot(
            ivp=getAbelEquation(), 
            solvers=[RKF45(
                atol=5e-4, 
                initStepSize=5e-2,
                minStepSize=0.00001,
                maxStepSize=1.0,
                minStepScale=0.1,
                maxStepScale=4.0,
            )], 
            filenamePrefix="rungeKuttaAdaptiveAbel")

    elseif exampleName == "rungeKuttaAdaptiveLogistic"
        NumOdeTutorial.solveAndPlot(
            ivp=getLogisticODE(
                initPop=1.0,
                capacity=60.0,
                growthRate=0.1
            ), 
            solvers=[RKF45(
                atol=5e-4, 
                initStepSize=1.0,#5e-2,
                minStepSize=0.00001,
                maxStepSize=5.0,
                minStepScale=0.1,
                maxStepScale=4.0,
            )], 
            filenamePrefix="rungeKuttaAdaptiveLogistic")

    elseif exampleName == "rungeKuttaAdaptiveCosineStable"
        NumOdeTutorial.solveAndPlot(
            ivp=getStableODEProblem(), 
            solvers=[RKF45(
                atol=1e-5, 
                initStepSize=5e-2,
                minStepSize=0.00001,
                maxStepSize=1.0,
                minStepScale=0.1,
                maxStepScale=4.0,
            )], 
        filenamePrefix="rungeKuttaAdaptiveCosineStable")

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
