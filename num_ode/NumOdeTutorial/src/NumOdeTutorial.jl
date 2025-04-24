
module NumOdeTutorial
include("./ForwardEuler.jl")
include("./ODELib.jl")

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
