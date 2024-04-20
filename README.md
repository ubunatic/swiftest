# Swiftest

## Usage
To use the Swiftest package, follow these steps:

1. Add the package as dependency in your `Package.swift`:
   ```swift
   dependencies: [
        .package(url: "https://github.com/ubunatic/swiftest.git", from: "1.0.0")
   ]
   ```

2. Create test targets:
   ```swift
   targets: [
       // ...
       // Swiftest Targets:
       .target(name: "TestSuites", dependencies: ["Swiftest"]),
       .executableTarget(name: "TestMain", dependencies: ["TestSuites"]),
   ]
   ```

3. Create test suites in `Sources/TestSuites`:
   ```swift
   import Foundation
   import Swiftest

   func myTest() throws { try AssertEqual(1, 1, "1 == 1") }

   public class TestSuite: Suite {
       public override init() {
           super.init()
           self.add("myTest", myTest)
       }
   }
   ```

4. Create test executable in `Sources/TestMain`:
   ```swift
   import TestSuite
   try TestSuite().run()
   ```

5. Run the tests:
   ```bash
   swift run TestMain
   ```
