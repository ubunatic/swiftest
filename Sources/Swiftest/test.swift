import Foundation


func esc(_ s: String, _ code: String = "0;0m") -> String { return "\u{001B}[\(code)\(s)\u{001B}[0;0m" }
func red(_ s: String)        -> String { return esc(s, "0;31m") }
func green(_ s: String)      -> String { return esc(s, "0;32m") }
func bold(_ s: String)       -> String { return esc(s, "1m")    }
func bold_red(_ s: String)   -> String { return esc(s, "1;31m") }
func bold_green(_ s: String) -> String { return esc(s, "1;32m") }
func bold_white(_ s: String) -> String { return esc(s, "1;37m") }

public typealias TestFunc = () throws -> Void
public typealias NamedTest = (String, TestFunc)

public protocol Testable {
    func tests() -> [NamedTest]
}

// Suite is a base class for test classes to inherit from.
// It provides an assert method that prints a message if the condition is false.
// It also provides a run method that runs all the tests in the suite.
open class Suite {
    // default initializer, adds tests using the Testable protocol
    public init() { addTests() }

    // debug initializer, allows to run tests in silent mode and disable the Testable protocol
    public init(slient: Bool = false, tests: [NamedTest] = []) {
        self.slient = slient
        self.tests = tests
        self.addTests()
    }

    private func addTests() {
        if let testableSelf = self as? Testable {
            testableSelf.tests().forEach { self.add($0.0, $0.1) }
        }
        if self.tests.isEmpty {
            print("\(bold("Warning")): \(type(of: self)) has no tests defined")
            return
        }
        if debug {
            print("Using \(tests.count) tests from \(type(of: self))")
        }
    }

    public var debug = ProcessInfo.processInfo.environment["DEBUG"] != ""
    public var slient = false
    public var tests: [(String, TestFunc)] = []
    public var errors: [Int: (String, Error)] = [:]
    public var done: [Int: Bool] = [:]

    public func add(_ name: String, _ fn: @escaping TestFunc) { tests.append((name, fn)) }
    public func name() -> String { return String(describing: type(of: self)) }
    public func print(_ message: String) { if !slient { Swift.print(message) } }

    public func run(_ name: String, _ fn: TestFunc) -> Error? {
        do    { try fn() }
        catch { return error }
        return nil
    }

    public func run(failOnErrors: Bool = true) throws {
        print("Running Test Suite: \(bold(name()))")

        for (i, (name, fn)) in tests.enumerated() {
            if done[i] != nil { continue }
            done[i] = true
            guard let err = run(name, fn) else {
                print("\(bold_green("OK")):   \(name)")
                continue
            }
            print("\(bold_red("FAIL")): \(bold_white(name)):")
            print("      \(err)")
            errors[i] = (name, err)
        }

        if failOnErrors && !errors.isEmpty {
            throw Assertion.assertionFailed("Suite \(type(of: self)) failed \(errors.count) of \(tests.count) tests")
        }
    }
}

