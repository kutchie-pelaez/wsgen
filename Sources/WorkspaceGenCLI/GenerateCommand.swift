import Foundation
import SwiftCLI
import Rainbow

final class GenerateCommand {

    private let start = CFAbsoluteTimeGetCurrent()

    @Flag("-q", "--quietly", description: "Completly disable logs")
    var quietly: Bool

    // MARK: - Routable

    let name = "generate"

    let shortDescription = "Generates xcode workspace file based on Workspacefile"
}

// MARK: - Command

extension GenerateCommand: Command {

    func execute() throws {

    }
}

// MARK: - Private

private extension GenerateCommand {

    var milisecondsPassed: Int {
        let diff = CFAbsoluteTimeGetCurrent() - start

        return Int(diff * 1000)
    }

    func stdout(_ content: String, terminator: String = "\n") {
        guard !quietly else { return }

        stdout.print(content, terminator: terminator)
    }
}
