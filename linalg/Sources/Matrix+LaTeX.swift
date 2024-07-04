
/// Extension to support printing to LaTeX format.
extension Matrix where ElementType: CustomStringConvertible {
    /// Represent the matrix to a LaTeX 'bmatrix' environment (from the 'amsmath' package).
    func toLaTeX() -> String {
        // we store the full LaTeX representation in 'latexRepresentation'
        // we begin the matrix by opening the bmatrix environment
        var latexRepresentation = "\\begin{bmatrix}\n"
        
        for row in 0..<self.nRows {
            // we first convert each element into a string representation
            var rowElements: [String] = []
            for col in 0..<self.nCols {
                let elem = self[row, col]

                // convert element to string
                rowElements.append("\(elem)")
            }

            // merge all elements in the row, separated by "&" and followed by a double slash
            let rowRepresentation = rowElements.joined(separator: " & ") + "\\\\" 

            // add the row to the rest of the matrix
            latexRepresentation += rowRepresentation + "\n"
        }

        // close the bmatrix environment
        latexRepresentation += "\\end{bmatrix}\n"

        return latexRepresentation
    }
}
