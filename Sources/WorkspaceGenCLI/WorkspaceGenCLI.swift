import Foundation
import SwiftCLI

public final class WorkspaceGenCLI {
    public init() { }

    @discardableResult
    public func execute(arguments: [String]? = nil) -> Int32 {
        let status: Int32

        if let arguments = arguments {
            status = cli.go(with: arguments)
        } else {
            status = cli.go()
        }

        return status
    }

    private lazy var cli: CLI = {
        let cli = CLI(
            name: "wsgen",
            version: "1.0.0",
            commands: [
                GenerateCommand()
            ]
        )

        cli.helpCommand = nil

        return cli
    }()
}
