import Foundation

public enum Assertion: Error { case assertionFailed(String) }

public func Assert(_ condition: Bool, _ message: String, file: StaticString = #file, line: UInt = #line) throws {
    if !condition {
        throw Assertion.assertionFailed("\(message) at \(file):\(line)")
    }
}

public func AssertEqual<T: Equatable>(_ expected: T, _ got: T, _ message: String, file: StaticString = #file, line: UInt = #line) throws {
    try Assert(expected == got, "\(message), expected: \(expected) got: \(got)", file: file, line: line)
}

public func AssertNil<T>(_ got: T?, _ message: String, file: StaticString = #file, line: UInt = #line) throws {
    try Assert(got == nil, "\(message), expected: nil, got: \(got.debugDescription)", file: file, line: line)
}

public func AssertNotNil<T>(_ got: T?, _ message: String, file: StaticString = #file, line: UInt = #line) throws {
    try Assert(got != nil, "\(message), expected: not nil of type \(got.debugDescription)", file: file, line: line)
}

public func AssertThrows<T>(_ fn: () throws -> T, _ message: String, file: StaticString = #file, line: UInt = #line) throws {
    do {
        _ = try fn()
        throw Assertion.assertionFailed("\(message), expected: throws, got: no throw at \(file):\(line)")
    } catch {
        return
    }
}

public func AssertNotThrows<T>(_ fn: () throws -> T, _ message: String, file: StaticString = #file, line: UInt = #line) throws {
    do {
        _ = try fn()
    } catch {
        throw Assertion.assertionFailed("\(message), expected: no throw, got: \(error) at \(file):\(line)")
    }
}

public func AssertLen<T>(_ expected: Int, _ got: [T], _ message: String, file: StaticString = #file, line: UInt = #line) throws {
    try AssertEqual(expected, got.count, "\(message), expected length,", file: file, line: line)
}

public func AssertEmpty<T>(_ got: [T], _ message: String, file: StaticString = #file, line: UInt = #line) throws {
    try Assert(got.isEmpty, "\(message), expected empty, got: \(got)", file: file, line: line)
}

public func AssertNotEmpty<T>(_ got: [T], _ message: String, file: StaticString = #file, line: UInt = #line) throws {
    try Assert(!got.isEmpty, "\(message), expected not empty, got: \(got)", file: file, line: line)
}
