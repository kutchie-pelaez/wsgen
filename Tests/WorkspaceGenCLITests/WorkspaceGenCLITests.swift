@testable import WorkspaceGenCLI
import XCTest
import PathKit
import XMLCoder

// MARK: - Fixture files paths

private let fixturesPath = Path(#file).parent().parent().parent() + "Fixtures"
private let fixturesManifestPath = fixturesPath + "workspace.yml"
private let fixturesXCWorkspaceFolderPath = fixturesPath + "WorkspaceName.xcworkspace"
private let fixturesXCWorkspaceContentsFolderPath = fixturesXCWorkspaceFolderPath + "contents.xcworkspacedata"

// MARK: - Expectations

private let expectedXCWorkspaceItems = [
    "File",
    "RecursiveFile",
    "Folder",
    "RecursiveFolder",
    "Package",
    "RecursivePackage",
    "Project",
    "RecursiveProject"
]

// MARK: - Tests

final class WorkspaceGenCLITests: XCTestCase {

    func test1_executeCLI() {
        let cli = WorkspaceGenCLI()
        let status = cli.execute(arguments:
            [
                "generate",
                fixturesManifestPath.string,
                fixturesPath.string,
            ]
        )

        XCTAssert(status == 0)
    }

    func test2_checkGeneratedXCWorkspaceExistence() {
        XCTAssert(
            fixturesXCWorkspaceFolderPath.exists &&
            fixturesXCWorkspaceContentsFolderPath.exists
        )
    }

    func test3_verifyGeneratedXCWorkspaceStructure() {
        do {
            let decoder = XMLDecoder()
            let data = try fixturesXCWorkspaceContentsFolderPath.read()
            let workspace = try decoder.decode(Workspace.self, from: data)
            let generatedXCWorkspaceItems = workspace
                .fileRefs
                .map { $0.name }

            XCTAssert(generatedXCWorkspaceItems == expectedXCWorkspaceItems)
        } catch {
            XCTAssert(false)
        }
    }
}
