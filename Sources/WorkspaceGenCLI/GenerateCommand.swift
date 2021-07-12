import Foundation
import SwiftCLI
import Rainbow
import Core
import PathKit
import Yams

final class GenerateCommand {

    @Param
    var workspace_name: String

    @Param
    var input_path: String?

    @Param
    var output_path: String?

    @Flag("-q", "--quietly", description: "Completly disable logs")
    var quietly: Bool

    // MARK: - Routable

    let name = "generate"

    let shortDescription = "Generates xcode workspace file based on Workspacefile"
}

// MARK: - Command

extension GenerateCommand: Command {

    func execute() throws {
        let workspacefileInputPath: Path
        if let providedInputPath = input_path {
            workspacefileInputPath = .init(providedInputPath)
        } else {
            workspacefileInputPath = .current + "Workspacefile"
        }

        let decoder = YAMLDecoder()
        let workspacefileData = try workspacefileInputPath.read()
        let workspacefile = try decoder.decode(Workspacefile.self, from: workspacefileData)
        let generator = WorkspaceXMLGenerator(workspacefile: workspacefile)
        let generatedRawXMLString = try generator.generateRawStringFromWorkspacefile()

        guard let xmlData = generatedRawXMLString.data(using: .utf8) else {
            throw GenerateCommandError.invalidXMLData
        }

        let workspaceOutputPath: Path
        if let providedOutputPath = output_path {
            workspaceOutputPath = .init(providedOutputPath) + "\(workspace_name).xcworkspace"
        } else {
            workspaceOutputPath = .current + "\(workspace_name).xcworkspace"
        }

        try workspaceOutputPath.mkdir()
        let workspaceContentsPath = workspaceOutputPath + "contents.xcworkspacedata"
        try workspaceContentsPath.write(xmlData)

        stdout("✅ Successfully generated workspace at \(workspaceOutputPath)".green)
    }
}

// MARK: - Private

private extension GenerateCommand {

    func stdout(_ content: String, terminator: String = "\n") {
        guard !quietly else { return }

        stdout.print(content, terminator: terminator)
    }
}

// MARK: - Generation errors

private enum GenerateCommandError: Error {
    case invalidXMLData
}
