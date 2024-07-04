
import XCTest
@testable import LinAlgTutorials

/// Tests for the various initialisers
final class MatrixInitTests: XCTestCase {

    /// Test to verify that a column vector can be constructed.
    public func testInitColVector() {
        let mat = Matrix<Int>(columnVector: [3, 65, -6989, -1])

        XCTAssertEqual(mat.nRows, 4)
        XCTAssertEqual(mat.nCols, 1)

        XCTAssertEqual(mat.elements[0], 3)
        XCTAssertEqual(mat.elements[1], 65)
        XCTAssertEqual(mat.elements[2], -6989)
        XCTAssertEqual(mat.elements[3], -1)
    }
        

    /// Test to verify that a Matrix can be constructed from an array of rows
    public func testInit2DArrayRowMajor() {
        let mat = Matrix<Int>(rows: [
            [1,2,3],
            [4,5,6],
            [7,8,9],
            [10,11,12]
        ])

        XCTAssertEqual(mat.nRows, 4)
        XCTAssertEqual(mat.nCols, 3)

        XCTAssertEqual(mat.elements[0], 1)
        XCTAssertEqual(mat.elements[1], 4)
        XCTAssertEqual(mat.elements[2], 7)
        XCTAssertEqual(mat.elements[3], 10)
        XCTAssertEqual(mat.elements[4], 2)
        XCTAssertEqual(mat.elements[5], 5)
        XCTAssertEqual(mat.elements[6], 8)
        XCTAssertEqual(mat.elements[7], 11)
        XCTAssertEqual(mat.elements[8], 3)
        XCTAssertEqual(mat.elements[9], 6)
        XCTAssertEqual(mat.elements[10], 9)
        XCTAssertEqual(mat.elements[11], 12)
    }

    /// Test to verify that a matrix can be constructed from an array of elements in row-major order.
    public func testInit1DArrayRowMajor() {
        let mat = Matrix<Int>(elementsRowMajor: [
            1,2,3,
            4,5,6,
            7,8,9,
            10,11,12
        ], numRows: 4)

        XCTAssertEqual(mat.nRows, 4)
        XCTAssertEqual(mat.nCols, 3)

        XCTAssertEqual(mat.elements[0], 1)
        XCTAssertEqual(mat.elements[1], 4)
        XCTAssertEqual(mat.elements[2], 7)
        XCTAssertEqual(mat.elements[3], 10)
        XCTAssertEqual(mat.elements[4], 2)
        XCTAssertEqual(mat.elements[5], 5)
        XCTAssertEqual(mat.elements[6], 8)
        XCTAssertEqual(mat.elements[7], 11)
        XCTAssertEqual(mat.elements[8], 3)
        XCTAssertEqual(mat.elements[9], 6)
        XCTAssertEqual(mat.elements[10], 9)
        XCTAssertEqual(mat.elements[11], 12)
    }

    /// Test to verify that a Matrix can be constructed from an array of columns.
    public func testInit2DArrayColMajor() {
        let mat = Matrix<Int>(columns: [
            [1,2,3],
            [4,5,6],
            [7,8,9],
            [10,11,12]
        ])

        XCTAssertEqual(mat.nRows, 3)
        XCTAssertEqual(mat.nCols, 4)

        XCTAssertEqual(mat.elements[0], 1)
        XCTAssertEqual(mat.elements[1], 2)
        XCTAssertEqual(mat.elements[2], 3)
        XCTAssertEqual(mat.elements[3], 4)
        XCTAssertEqual(mat.elements[4], 5)
        XCTAssertEqual(mat.elements[5], 6)
        XCTAssertEqual(mat.elements[6], 7)
        XCTAssertEqual(mat.elements[7], 8)
        XCTAssertEqual(mat.elements[8], 9)
        XCTAssertEqual(mat.elements[9], 10)
        XCTAssertEqual(mat.elements[10], 11)
        XCTAssertEqual(mat.elements[11], 12)
    }

    /// Test to verify that a Matrix can be constructed from an array of elements in column-major order.
    public func testInit1DArrayColMajor() {
        let mat = Matrix<Int>(elementsColMajor: [
            1,2,3,
            4,5,6,
            7,8,9,
            10,11,12
        ], numCols: 4)

        XCTAssertEqual(mat.nRows, 3)
        XCTAssertEqual(mat.nCols, 4)

        XCTAssertEqual(mat.elements[0], 1)
        XCTAssertEqual(mat.elements[1], 2)
        XCTAssertEqual(mat.elements[2], 3)
        XCTAssertEqual(mat.elements[3], 4)
        XCTAssertEqual(mat.elements[4], 5)
        XCTAssertEqual(mat.elements[5], 6)
        XCTAssertEqual(mat.elements[6], 7)
        XCTAssertEqual(mat.elements[7], 8)
        XCTAssertEqual(mat.elements[8], 9)
        XCTAssertEqual(mat.elements[9], 10)
        XCTAssertEqual(mat.elements[10], 11)
        XCTAssertEqual(mat.elements[11], 12)
    }
}
