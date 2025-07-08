
module NumOdeTutorial
include("./ForwardEuler.jl")
include("./ODELib.jl")
include("./BackwardEuler.jl")

function main()
    if length(ARGS) != 1
        println("Error: please specify exactly one argument with the name of the example you wish to run.")
        exit(1)
    end

    exampleName = ARGS[1]

    if exampleName == "forwardEulerStable"
        NumOdeTutorial.solveAndPlotForwardEuler(getStableODEProblem(), [10, 20, 100, 2000], "./ForwardEulerStable.png")
    elseif exampleName == "forwardEulerUnstable"
        NumOdeTutorial.solveAndPlotForwardEuler(getUnstableODEProblem(), [5, 10, 50, 1000], "./ForwardEulerUnstable.png")
    elseif exampleName == "backwardEulerStable"
        NumOdeTutorial.solveAndPlotBackwardEuler(getStableODEProblem(), [10, 20, 100, 2000], "./BackwardEulerStable.png")
    elseif exampleName == "backwardEulerUnstable"
        NumOdeTutorial.solveAndPlotBackwardEuler(getUnstableODEProblem(), [5, 10, 50, 1000], "./BackwardEulerUnstable.png")
    elseif exampleName == "forwardEulerRiccati"
        NumOdeTutorial.solveAndPlotForwardEuler(getRiccatiODEProblem(), [5, 10, 1000, 5000], "./ForwardEulerRiccatiExample.png")
    elseif exampleName == "backwardEulerRiccati"
        NumOdeTutorial.solveAndPlotBackwardEuler(getRiccatiODEProblem(), [5, 5000], "./BackwardEulerRiccatiExample.png")
    elseif exampleName == "forwardEulerStiff"
        NumOdeTutorial.solveAndPlotForwardEuler(getStiffODEProblem(), [25, 100], "./ForwardEulerStiffExample.png")
    elseif exampleName == "backwardEulerStiff"
        NumOdeTutorial.solveAndPlotBackwardEuler(getStiffODEProblem(), [25, 100], "./BackwardEulerStiffExample.png")
    elseif exampleName == "forwardEulerQuadex"
        NumOdeTutorial.solveAndPlotForwardEuler(getQuadexODEProblem(), [2500, 5000], "./ForwardEulerQuadex.png")
    elseif exampleName == "backwardEulerQuadex"
        NumOdeTutorial.solveAndPlotBackwardEuler(getQuadexODEProblem(), [2500, 5000], "./BackwardEulerQuadex.png")
    elseif exampleName == "forwardEulerFlame"
        NumOdeTutorial.solveAndPlotForwardEuler(getStiffODEProblemFlame(0.01), [70, 100, 5000], "./ForwardEulerFlameEasy.png")
    elseif exampleName == "backwardEulerFlame"
        NumOdeTutorial.solveAndPlotBackwardEuler(getStiffODEProblemFlame(0.01), [70, 100, 5000], "./BackwardEulerFlameEasy.png")
    elseif exampleName == "forwardEulerFlameHard"
        NumOdeTutorial.solveAndPlotForwardEuler(getStiffODEProblemFlame(0.0001), [5000, 10000, 20000], "./ForwardEulerFlameHard.png")
    elseif exampleName == "backwardEulerFlameHard"
        NumOdeTutorial.solveAndPlotBackwardEuler(getStiffODEProblemFlame(0.0001), [70, 100, 500, 1000], "./BackwardEulerFlameHard.png")
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
