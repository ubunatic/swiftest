import Foundation
import Swiftest

public class TestSuite: Suite {
    public override init() {
        super.init()
        self.add("testSuite", testSuite)
    }

    public func testSuite() throws {
        func ok()     throws { try AssertEqual(1, 1, "1 == 1") }
        func fail()   throws { try Assert(false, "SelfTest: must fail!") }
        func failEq() throws { try AssertEqual(1, 2, "fail on 1 != 2")}

        let debug    = ProcessInfo.processInfo.environment["DEBUG"] != ""
        let s = Suite(slient: !debug)
        s.add("test 1 == 1", ok)
        try! s.run()
        try Assert(s.errors.isEmpty, "errors.count: \(s.errors.count) must be 0")

        s.add("test assert fail", fail)
        s.add("test 1 == 2", failEq)
        try! s.run(failOnErrors: false)
        try Assert(s.errors.count == 2, "errors.count: \(s.errors.count) must be 2")

        do    { try s.run(); assert(false, "must fail") }
        catch { try Assert(s.errors.count == 2, "errors.count: \(s.errors.count) must still be 2") }
    }
}

