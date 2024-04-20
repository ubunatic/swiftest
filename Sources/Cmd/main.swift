import Foundation
import ArgumentParser

@main
struct SwiftestCli: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Swiftest is a unit testing framework for Swift",
        version: "1.0.0",
        subcommands: [Run.self],
        defaultSubcommand: Run.self
    )
}

extension SwiftestCli {
    struct Run: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Swiftest Run does nothing")
        mutating func run() {
            print("swiftest run: not implemented")
        }
    }
}
