import Foundation
import SwiftCLI
import Rainbow
import Core
import PathKit
import Yams

final class GenerateCommand {

    @Param
    var input: String?

    @Param
    var output: String?

    @Flag("-q", "--quietly", description: "Completly disable logs")
    var quietly: Bool

    // MARK: - Routable

    let name = "generate"

    let shortDescription = "Generates workspace file based on provided manifest"
}

// MARK: - Command

extension GenerateCommand: Command {

    func execute() throws {
        Manifest.outputPath = output ?? Path.current.string
        executeNonThrowing()
    }

    private func executeNonThrowing() {
        do {
            let xmlData = try generatedWorkspaceData(at: inputPath)
            let manifest = try manifest(at: inputPath)

            let outputPath = outputPath(for: manifest)
            let tmpOutputPath = outputPath.parent() + "tmp_\(outputPath.lastComponent)"

            let contentsFileName = "contents.xcworkspacedata"
            let workspaceContentsPath = outputPath + contentsFileName
            let tmpWorkspaceContentsPath = tmpOutputPath + contentsFileName

            if outputPath.exists {
                try tmpOutputPath.mkdir()
                try tmpWorkspaceContentsPath.write(xmlData)
                try outputPath.delete()
                try tmpOutputPath.move(outputPath)
            } else {
                try outputPath.mkdir()
                try workspaceContentsPath.write(xmlData)
            }

            stdout("✅ Successfully generated workspace at \(outputPath)")
        } catch let error {
            logError(error)
        }
    }
}

// MARK: - Private

extension GenerateCommand {

    private var inputPath: Path {
        if let providedInputPath = input {
            return .init(providedInputPath)
        } else {
            return .current + "workspace.yml"
        }
    }

    private func outputPath(for manifest: Manifest) -> Path {
        let xcworkspaceName = "\(manifest.name).xcworkspace"

        if let providedOutputPath = output {
            return .init(providedOutputPath) + xcworkspaceName
        } else {
            return .current + xcworkspaceName
        }
    }

    private func manifest(at path: Path) throws -> Manifest {
        let decoder = YAMLDecoder()
        let manifestData = try inputPath.read()
        let manifest = try decoder.decode(Manifest.self, from: manifestData)

        return manifest
    }

    private func generatedWorkspaceData(at path: Path) throws -> Data {
        let manifest = try manifest(at: path)

        return try manifest.generateXMLData()
    }

    private func logError(_ error: Error) {
        switch error {
        case let generateCommandError as GenerateCommandError:
            switch generateCommandError {
            case .invalidXMLString:
                stderr("Invalid XML string")
            }

        case let manifestDecodingError as Manifest.ManifestDecodingError:
            switch manifestDecodingError {
            case .manifestOutputPathIsNotSet:
                stderr("Manifest output path is not set")
            }

        default:
            stderr(error.localizedDescription)
        }
    }

    private func stdout(_ content: String, terminator: String = "\n") {
        guard !quietly else { return }

        stdout.print(content.green, terminator: terminator)
    }

    private func stderr(_ content: String, terminator: String = "\n") {
        guard !quietly else { return }

        stderr.print(content.red, terminator: terminator)
    }
}

// MARK: - Generation errors

private enum GenerateCommandError: Error {
    case invalidXMLString
}
