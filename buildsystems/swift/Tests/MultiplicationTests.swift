
import Foundation
import XCTest

// This import statement annotated with @testable, gives XCTest access to all 
// the code in 'NewProject'
@testable import NewProject

/// Test cases for the `multiplyByTwo` function.
final class MultiplicationTests: XCTestCase {
	/// Test to verify that positive inputs work properly.
	func testPositiveNumbers() {
		XCTAssertEqual(multiplyByTwo(x: 4), 8)
		XCTAssertEqual(multiplyByTwo(x: 10), 20)
	}
	
	/// Test to verify that negative inputs work properly.
	func testNegativeNumbers() {
		XCTAssertEqual(multiplyByTwo(x: -5), -10)
	}
}
