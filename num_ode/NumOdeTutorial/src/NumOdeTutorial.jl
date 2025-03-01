
module NumOdeTutorial
include("./ForwardEuler.jl")

function main()
    if length(ARGS) != 1
        println("Error: please specify exactly one argument with the name of the example you wish to run.")
        exit(1)
    end

    exampleName = ARGS[1]

    if exampleName == "forwardEulerExample1"
        ForwardEuler.runExample1()
    elseif exampleName == "forwardEulerExample2"
        ForwardEuler.runExample2()
    else
        println("Invalid example name '$(exampleName)'.")
        exit(1)
    end
end


# run the program
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end

end # module NumOdeTutorial
