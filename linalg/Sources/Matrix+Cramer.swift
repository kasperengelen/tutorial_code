
/// Extension for solving systems of linear equations using Cramer's rule.
public extension Matrix where ElementType: FloatingPoint {
    /// Create a copy of the matrix without the specified row and column.
    func minorMatrix(skipRow: Int, skipCol: Int) -> Matrix<ElementType> {
        var newElems: [ElementType] = []
        newElems.reserveCapacity((self.nRows-1)*(self.nCols-1))

        // add elements of the old matrix to the new matrix in column-major order
        for col in 0..<self.nCols {
            for row in 0..<self.nRows {
                // skip all elements on the specified row and column
                if col == skipCol || row == skipRow {
                    continue
                }

                newElems.append(self[row, col])
            }
        }

        return Matrix(elementsColMajor: newElems, numCols: self.nCols-1)
    }

    /// Compute the determinant by taking the co-factor expansion over the specified row
    func determinant(rowNr: Int = 0) -> ElementType {
        // determinant is only defined for square matrices
        precondition(self.nRows == self.nCols)

        if(self.nRows == 2) {
            // rule of Sarrus
            return self[0,0] * self[1,1] - self[0,1] * self[1,0]
        } else {
            var determinant: ElementType = 0

            // compute the co-factors
            for col in 0..<self.nCols {
                // compute determinant of the minor matrix
                let subMatrix = self.minorMatrix(skipRow: rowNr, skipCol: col)
                let subDet = subMatrix.determinant()

                // sign depends on whether row and col numbers are even/uneven
                if((rowNr + col) % 2 == 0) {
                    // add the co-factor to the determinant
                    determinant += self[rowNr, col] * subDet
                } else {
                    determinant -= self[rowNr, col] * subDet
                }
            }

            return determinant
        }
    }

    /// Modify the matrix to replace the specified column with the values
    mutating func setColumn(col: Int, newValue: [ElementType]) -> Self {
        // sizes of the matrix and the new column need to match
        precondition(newValue.count == self.nRows)

        for row in 0...newValue.count-1 {
            self[row, col] = newValue[row]
        }

        return self
    }

    /// Return a new matrix with the same value except that the specified column has been replaced.
    func withColumnReplaced(col: Int, newValue: [ElementType]) -> Matrix<ElementType> {
        // sizes of the matrix and the new column need to match
        precondition(newValue.count == self.nRows)

        // copy
        var newMatrix = self

        return newMatrix.setColumn(col: col, newValue: newValue)
    }

    /// Solve the system A*x = b for the specified vector b using Cramer's rule.
    func solveWithCramer(b: [ElementType]) -> [ElementType] {
            // the vector b needs to have the same size as A.
            precondition(b.count == self.nRows)

            // reserve space for the solution vector
            var x: [ElementType] = []
            x.reserveCapacity(self.nRows)

            let detA = self.determinant()

            // apply Cramer's rule for every element of x.
            for i in 0..<self.nCols {
                let Ai = self.withColumnReplaced(col: i, newValue: b)
                let detAi = Ai.determinant()

                x.append(detAi / detA)
            }

            return x
    }
}
