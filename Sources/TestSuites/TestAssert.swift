import Swiftest

public class TestAssert: Suite, Testable {
    public func tests() -> [NamedTest] {
        return [
            ("testAssert", testAssert),
        ]
    }

    func testAssert() throws {
        try Assert(true, "true is true")
        try AssertEqual(1, 1, "1 == 1")
        try AssertNil(nil as Int?, "nil is nil")
        try AssertNotNil(1 as Int?, "1 is not nil")
        try AssertThrows({ throw Assertion.assertionFailed("test") }, "throws")
        try AssertNotThrows({ return 1 }, "not throws")
        try AssertLen(3, [1,2,3], "len 3")
        try AssertEmpty([], "empty")
        try AssertNotEmpty([1], "not empty")
    }
}
