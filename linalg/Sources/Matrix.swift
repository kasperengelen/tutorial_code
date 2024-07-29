
/// Represents an n-by-m Matrix
public struct Matrix<ElementType> {
    /// Contents of the matrix
    public private(set) var elements: [ElementType]

    /// Number of rows
    public private(set) var nRows: Int

    /// Number of columns
    public private(set) var nCols: Int

    /// Create a Matrix that is a column vector.
    init(columnVector: [ElementType]) {
        self.nCols = 1
        self.nRows = columnVector.count
        self.elements = columnVector
    }

    /// Create a Matrix from an array of rows.
    init(rows: [[ElementType]]) {
        // assert that the data is non-empty
        precondition(!rows.isEmpty)
        precondition(!rows[0].isEmpty)

        self.nRows = rows.count
        self.nCols = rows[0].count

        if rows.count == 1 {
            self.elements = rows[0]
            return
        } else {
            self.elements = []

            // reserve capacity such that we do not repeatedly re-size the array
            self.elements.reserveCapacity(self.nRows * self.nCols)

            // add elements in column-major order
            for col in 0..<self.nCols {
                for row in 0..<self.nRows {
                    // assert that all rows have the same number of elements
                    assert(rows[row].count == self.nCols)
                    self.elements.append(rows[row][col])
                }
            }

            return
        }
    }

    /// Create a Matrix from an array of columns.
    init(columns: [[ElementType]]) {
        // assert that the data is non-empty
        precondition(columns.count > 0)
        precondition(columns[0].count > 0)

        self.nCols = columns.count
        self.nRows = columns[0].count
        
        if columns.count == 1 {
            self.elements = columns[0]
        } else {
            self.elements = []

            // reserve capacity such that we do not repeatedly re-size the array
            self.elements.reserveCapacity(self.nRows * self.nCols)
            
            for col in columns {
                // assert that all columns have the same length
                assert(col.count == self.nRows)
                self.elements.append(contentsOf: col)
            }
        }
    }

    /// Construct a Matrix given a number of columns and elements in column-major order.
    init(elementsColMajor: [ElementType], numCols: Int) {
        // make sure that the number of elements corresponds the number of columns
        precondition(elementsColMajor.count % numCols == 0)

        // we can just copy the elements, since they are already in column-major order
        self.elements = elementsColMajor

        self.nCols = numCols
        self.nRows = self.elements.count / self.nCols
    }

    /// Construct a Matrix given a number of rows from elements in row-major order.
    init(elementsRowMajor: [ElementType], numRows: Int) {
        // make sure that the number of elements corresponds the number of rows
        precondition(elementsRowMajor.count % numRows == 0)

        self.elements = []

        // reserve capacity such that we do not repeatedly re-size the array
        self.elements.reserveCapacity(elementsRowMajor.count)

        self.nRows = numRows
        self.nCols = elementsRowMajor.count / numRows

        // we will have to re-order the elements to column-major
        for col in 0..<self.nCols {
            for row in 0..<self.nRows {
                // compute the index
                let rowMajorIdx = rowColToRowMajorIdx(row: row, col: col) 
                
                // retrieve element
                let elem = elementsRowMajor[rowMajorIdx] 

                // append to the elements
                self.elements.append(elem) 
            }
        }
    }

    /// Get/set the n-th element. For vectors this will give the element at index n. For matrices, this will be the n-th element
    ///     in column-major order.
    public subscript(idx: Int) -> ElementType {
        get {
            precondition(idx >= 0 && idx < self.elements.count)
            
            return self.elements[idx]
        }
        set(newValue) {
            precondition(idx >= 0 && idx < self.elements.count)
            
            self.elements[idx] = newValue
        }
    }

    /// Get/set the element at the specified row and column.
    public subscript(row: Int, col: Int) -> ElementType {
        get {
            precondition(row >= 0 && row < self.nRows)
            precondition(col >= 0 && col < self.nCols)
            let idx = rowColToColMajorIdx(row: row, col: col)

            return self.elements[idx]
        }
        set(newValue) {
            precondition(row >= 0 && row < self.nRows)
            precondition(col >= 0 && col < self.nCols)
            let idx = rowColToColMajorIdx(row: row, col: col)

            self.elements[idx] = newValue
        }
    }

    /// Convert row and col number to column-major index
    private func rowColToColMajorIdx(row: Int, col: Int) -> Int {
        precondition(row >= 0 && row < self.nRows)
        precondition(col >= 0 && col < self.nCols)

        return col * self.nRows + row
    }

    /// Convert row and col number to row-major index
    private func rowColToRowMajorIdx(row: Int, col: Int) -> Int {
        precondition(row >= 0 && row < self.nRows)
        precondition(col >= 0 && col < self.nCols)

        return row * self.nCols + col
    }
}
