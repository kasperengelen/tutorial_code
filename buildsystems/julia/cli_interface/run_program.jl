
using FunctionDiff
using ArgParse
using Plots

"""
    parse_commandline()

Parse the command-line arguments passed to the program.

This will return a `Dict` with the following keys:
- `coeffs` an `Array{Float64}` with the coefficients, low order to higher order,
- `order` an integer with the order of the derivative,
- `plot` an optional string with the filename of the plot.
"""
function parse_commandline()
    settings = ArgParseSettings()

    @add_arg_table! settings begin
        "--coeffs"
            nargs = '+'
            #action = :store_arg
            arg_type = Float64
            required = true
        "--order"
            arg_type = Int
            default = 1
        "--plot"
            arg_type = String
            default = nothing

    end

    return parse_args(settings)
end

"""
   Run the program.
"""
function main()
    parsed_args = parse_commandline()

    coeffs = parsed_args["coeffs"]
    order = parsed_args["order"]

    polynom = FunctionDiff.getPolynomial(coeffs)
    higher_deriv = FunctionDiff.getHigherDerivative(polynom, order)

    println("Function: ", polynom)
    println("Order $order derivative: ", higher_deriv)

    filename = parsed_args["plot"]
    if !isnothing(filename)
        println("Plotting to '$filename' ...")
        pl = FunctionDiff.plotFunction(polynom, higher_deriv)
        savefig(pl, filename)
    end
end

# check that we are running the script and not importing it
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
