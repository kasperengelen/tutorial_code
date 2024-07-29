
// needed for String.padding(...)
import Foundation

/// Extension to support printing of the matrix to a String.
extension Matrix: CustomStringConvertible where ElementType: CustomStringConvertible {

    /// Compatible with the \() operator.
    public var description: String {
        // convert the elements of the matrix to strings column by column
        var colsWithStrings: [[String]] = []
        for col in 0..<self.nCols {
            // add every row to the column, and compute the width of the column
            var colWidth = 0
            var colElements: [String] = []
            for row in 0..<self.nRows {
                let repr = "\(self[row, col])" // convert element to string representation
                colElements.append(repr) // store element
                colWidth = max(colWidth, repr.count) // adjust width
            }


            // Since we want all elements in the column the have the same width,
            //  we adjust all elements in the column, to the width of the column
            for row in 0..<self.nRows {
                colElements[row] = colElements[row].padding(toLength: colWidth, withPad: " ", startingAt: 0)
            }

            // store column
            colsWithStrings.append(colElements)
        }

        // convert to row-major since we will print row by row
        var rowsWithStrings: [[String]] = []
        for row in 0..<self.nRows {
            var rowElements: [String] = []
            for col in 0..<self.nCols {
                rowElements.append(colsWithStrings[col][row])
            }
            rowsWithStrings.append(rowElements)
        }

        // store each row a as a string
        var joinedRows: [String] = []
        joinedRows.append("") // temporary placeholder
        for row in 0..<self.nRows {
            // join the elements of each row together, separated by whitespace
            joinedRows.append("| " + rowsWithStrings[row].joined(separator: "  ") + " |")
        }

        // Add top and bottom rows (these are just decorative)
        let rowStringLength: Int = joinedRows.last!.count // determine how many characters should be in the decorative rows
        let topAndBottomStrings: String = "+-" + String(repeating: " ", count: rowStringLength-4) + "-+"

        // add the decorative rows
        joinedRows[0] = topAndBottomStrings
        joinedRows.append(topAndBottomStrings)

        // join all rows together, separated by a newline
        return joinedRows.joined(separator: "\n")
    }
}
