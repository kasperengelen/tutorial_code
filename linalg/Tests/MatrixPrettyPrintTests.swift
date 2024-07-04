
import XCTest

@testable import LinAlgTutorials

/// Test for pretty printing
final class MatrixPrettyPrintTests: XCTestCase {

    public func testPrettyPrint4x3() {
        let mat = Matrix<Int>(rows: [
            [2, 3, 5],
            [3, 65, 32],
            [-6, -6989, 0],
            [-68, 1, 1]
        ])

        let expected = """
        +-              -+
        | 2    3      5  |
        | 3    65     32 |
        | -6   -6989  0  |
        | -68  1      1  |
        +-              -+
        """

        XCTAssertEqual(mat.description, expected)
        XCTAssertEqual("\(mat)", expected)
    }

    public func testPrettyPrintColumnVector() {
        let mat = Matrix<Int>(columnVector: [3, 65, -6989, -1])

        let expected = """
        +-     -+
        | 3     |
        | 65    |
        | -6989 |
        | -1    |
        +-     -+
        """

        XCTAssertEqual(mat.description, expected)
        XCTAssertEqual("\(mat)", expected)
    }

    /// Test to verify the LaTeX format
    public func testLaTeXRendering() {
        let mat = Matrix<Int>(rows: [
            [2, 3, 5],
            [3, 65, 32],
            [-6, -6989, 0],
            [-68, 1, 1]
        ])

        let expected = """
        \\begin{bmatrix}
        2 & 3 & 5\\\\
        3 & 65 & 32\\\\
        -6 & -6989 & 0\\\\
        -68 & 1 & 1\\\\
        \\end{bmatrix}
        
        """

        XCTAssertEqual(mat.toLaTeX(), expected)
    }
}
