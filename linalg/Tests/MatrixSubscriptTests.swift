
import XCTest

@testable import LinAlgTutorials

/// Tests for the subscript operator
final class MatrixSubscriptTests: XCTestCase {
    public func test2DSubscriptOperatorGet() {
        let mat = Matrix<Int>(rows: [
            [1,2,3],
            [4,5,6],
            [7,8,9],
            [10,11,12]
        ])

        XCTAssertEqual(mat[0,0], 1)
        XCTAssertEqual(mat[0,1], 2)
        XCTAssertEqual(mat[0,2], 3)

        XCTAssertEqual(mat[1,0], 4)
        XCTAssertEqual(mat[1,1], 5)
        XCTAssertEqual(mat[1,2], 6)

        XCTAssertEqual(mat[2,0], 7)
        XCTAssertEqual(mat[2,1], 8)
        XCTAssertEqual(mat[2,2], 9)

        XCTAssertEqual(mat[3,0], 10)
        XCTAssertEqual(mat[3,1], 11)
        XCTAssertEqual(mat[3,2], 12)
    }

    public func test2DSubscriptOperatorSet() {
        var mat = Matrix<Int>(rows: [
            [1,2,3],
            [4,5,6],
            [7,8,9],
            [10,11,12]
        ])

        // sanity check
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

        mat[0,2] = 55
        mat[1,0] = -6563

        XCTAssertEqual(mat.elements[0], 1)
        XCTAssertEqual(mat.elements[1], -6563)
        XCTAssertEqual(mat.elements[2], 7) // changed
        XCTAssertEqual(mat.elements[3], 10) // changed
        XCTAssertEqual(mat.elements[4], 2)
        XCTAssertEqual(mat.elements[5], 5)
        XCTAssertEqual(mat.elements[6], 8)
        XCTAssertEqual(mat.elements[7], 11)
        XCTAssertEqual(mat.elements[8], 55)
        XCTAssertEqual(mat.elements[9], 6)
        XCTAssertEqual(mat.elements[10], 9)
        XCTAssertEqual(mat.elements[11], 12)
    }

    public func test1DSubscriptOperatorGet() {
        let mat = Matrix<Int>(rows: [
            [1,2,3],
            [4,5,6],
            [7,8,9],
            [10,11,12]
        ])

        // check contents
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

        // verify that the operator works correctly
        XCTAssertEqual(mat.elements[0], mat[0])
        XCTAssertEqual(mat.elements[1], mat[1])
        XCTAssertEqual(mat.elements[2], mat[2])
        XCTAssertEqual(mat.elements[3], mat[3])
        XCTAssertEqual(mat.elements[4], mat[4])
        XCTAssertEqual(mat.elements[5], mat[5])
        XCTAssertEqual(mat.elements[6], mat[6])
        XCTAssertEqual(mat.elements[7], mat[7])
        XCTAssertEqual(mat.elements[8], mat[8])
        XCTAssertEqual(mat.elements[9], mat[9])
        XCTAssertEqual(mat.elements[10],mat[10])
        XCTAssertEqual(mat.elements[11],mat[11])
    }

    public func test1DSubscriptOperatorSet() {
        var mat = Matrix<Int>(rows: [
            [1,2,3],
            [4,5,6],
            [7,8,9],
            [10,11,12]
        ])

        // check contents
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

        // adjust element
        mat[9] = -58475
        mat[5] = 899


        // check contents
        XCTAssertEqual(mat.elements[0], 1)
        XCTAssertEqual(mat.elements[1], 4)
        XCTAssertEqual(mat.elements[2], 7)
        XCTAssertEqual(mat.elements[3], 10)
        XCTAssertEqual(mat.elements[4], 2)
        XCTAssertEqual(mat.elements[5], 899)
        XCTAssertEqual(mat.elements[6], 8)
        XCTAssertEqual(mat.elements[7], 11)
        XCTAssertEqual(mat.elements[8], 3)
        XCTAssertEqual(mat.elements[9], -58475)
        XCTAssertEqual(mat.elements[10], 9)
        XCTAssertEqual(mat.elements[11], 12)
    }
}
