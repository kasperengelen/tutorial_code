
module NumOdeTutorial

include("./ODELib.jl")
include("./SolverRunner.jl")
include("./ForwardEuler.jl")
include("./BackwardEuler.jl")

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
        NumOdeTutorial.solveAndPlot(ivp=getStableODEProblem(), solvers=[ForwardEuler(1.0), ForwardEuler(0.5), ForwardEuler(0.1), ForwardEuler(0.005)], filename="./ForwardEulerStable.png")
    elseif exampleName == "backwardEulerStable"
        NumOdeTutorial.solveAndPlot(ivp=getStableODEProblem(), solvers=[BackwardEuler(1.0), BackwardEuler(0.5), BackwardEuler(0.1), BackwardEuler(0.005)], filename="./BackwardEulerStable.png")
    
    elseif exampleName == "forwardEulerUnstable"
        NumOdeTutorial.solveAndPlot(ivp=getUnstableODEProblem(), solvers=[ForwardEuler(1.0), ForwardEuler(0.5), ForwardEuler(0.1), ForwardEuler(0.005)], filename="./ForwardEulerUnstable.png")
    elseif exampleName == "backwardEulerUnstable"
        NumOdeTutorial.solveAndPlot(ivp=getUnstableODEProblem(), solvers=[BackwardEuler(1.0), BackwardEuler(0.5), BackwardEuler(0.1), BackwardEuler(0.005)], filename="./BackwardEulerUnstable.png")
    
    elseif exampleName == "forwardEulerRiccati"
        NumOdeTutorial.solveAndPlot(ivp=getRiccatiODEProblem(), solvers=[ForwardEuler(0.2), ForwardEuler(0.1), ForwardEuler(0.001), ForwardEuler(0.0002)], filename="./ForwardEulerRiccatiExample.png")
    elseif exampleName == "backwardEulerRiccati"
        NumOdeTutorial.solveAndPlot(ivp=getRiccatiODEProblem(), solvers=[BackwardEuler(0.2), BackwardEuler(0.1), BackwardEuler(0.001), BackwardEuler(0.0002)], filename="./BackwardEulerRiccatiExample.png")
    
    elseif exampleName == "forwardEulerStiff"
        NumOdeTutorial.solveAndPlot(ivp=getStiffODEProblem(), solvers=[ForwardEuler(0.01), ForwardEuler(0.04)], filename="./ForwardEulerStiffExample.png")
    elseif exampleName == "backwardEulerStiff"
        NumOdeTutorial.solveAndPlot(ivp=getStiffODEProblem(), solvers=[BackwardEuler(0.01), BackwardEuler(0.04)], filename="./BackwardEulerStiffExample.png")

    elseif exampleName == "forwardEulerQuadex"
        NumOdeTutorial.solveAndPlot(ivp=getQuadexODEProblem(), solvers=[ForwardEuler(0.0004), ForwardEuler(0.0008)], filename="./ForwardEulerQuadex.png")
    elseif exampleName == "backwardEulerQuadex"
        NumOdeTutorial.solveAndPlot(ivp=getQuadexODEProblem(), solvers=[BackwardEuler(0.0004), BackwardEuler(0.0008)], filename="./BackwardEulerQuadex.png")

    elseif exampleName == "forwardEulerFlameEasy"
        NumOdeTutorial.solveAndPlot(ivp=getStiffODEProblemFlame(0.01), solvers=[ForwardEuler(0.04), ForwardEuler(2.0), ForwardEuler(2.85)], filename="./ForwardEulerFlameEasy.png")
    elseif exampleName == "backwardEulerFlameEasy"
        NumOdeTutorial.solveAndPlot(ivp=getStiffODEProblemFlame(0.01), solvers=[BackwardEuler(0.04), BackwardEuler(2.0), BackwardEuler(2.85)], filename="./BackwardEulerFlameEasy.png")
    
    elseif exampleName == "forwardEulerFlameHard"
        NumOdeTutorial.solveAndPlot(ivp=getStiffODEProblemFlame(0.0001), solvers=[ForwardEuler(1.0), ForwardEuler(2.0), ForwardEuler(4.0)], filename="./ForwardEulerFlameHard.png")
    elseif exampleName == "backwardEulerFlameHard"
        NumOdeTutorial.solveAndPlot(ivp=getStiffODEProblemFlame(0.0001), solvers=[BackwardEuler(20.0), BackwardEuler(40.0), BackwardEuler(200.0), BackwardEuler(285.7)], filename="./BackwardEulerFlameHard.png")

    elseif exampleName == "compareForwardBackwardEulerSimpleStiff"
        NumOdeTutorial.solveAndPlot(ivp=getStiffODEProblem(), solvers=[BackwardEuler(0.04), ForwardEuler(0.04)], filename="./CompareForwardBackwardEulerSimpleStiff.png")

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
