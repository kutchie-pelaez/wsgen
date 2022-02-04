@testable import WorkspaceGenCLI
import Core
import PathKit
import XCTest
import XMLCoder

// MARK: - Fixture files paths

private let fixturesPath = Path(#file).parent().parent().parent() + "Fixtures"
private let fixturesManifestPath = fixturesPath + "workspace.yml"
private let fixturesXCWorkspaceFolderPath = fixturesPath + "WorkspaceName.xcworkspace"
private let fixturesXCWorkspaceContentsFilePath = fixturesXCWorkspaceFolderPath + "contents.xcworkspacedata"
private let cacheName = "wsgen_tests"
private let cacheDomainPath = Cache.cacheDomainFolderPath(for: cacheName)
private let cachePath = Cache.cachePath(for: cacheName)

// MARK: - Expectations

private let expectedXCWorkspaceItems = [
    "RecursiveFolder",
    "Package",
    "File",
    "RecursiveFile",
    "Folder",
    "RecursivePackage",
    "Project",
    "RecursiveProject"
]

// MARK: - Tests

final class WorkspaceGenCLITests: XCTestCase {
    override class func setUp() {
        print("SETUP 🙂")
        Self.cleanup()
        Manifest.outputPath = fixturesManifestPath.string
    }

    override class func tearDown() {
        print("tearDown 🙂")
        Self.cleanup()
    }

    func test1_executeCLI() {
        XCTAssert(executionStatusWithoutCaching == 0)
    }

    func test2_checkGeneratedXCWorkspaceExistence() {

        XCTAssert(
            fixturesXCWorkspaceFolderPath.exists &&
            fixturesXCWorkspaceContentsFilePath.exists
        )
    }

    func test3_verifyGeneratedXCWorkspaceStructure() {
        do {
            let decoder = XMLDecoder()
            let data = try fixturesXCWorkspaceContentsFilePath.read()
            let workspace = try decoder.decode(Workspace.self, from: data)
            let generatedXCWorkspaceItems = workspace
                .fileRefs
                .map { $0.name }

            XCTAssert(generatedXCWorkspaceItems == expectedXCWorkspaceItems)
        } catch {
            XCTAssert(false)
        }
    }

    func test4_checkCacheDoesNotExist() {
        XCTAssertNil(cacheHash)
    }

    func test5_checkExpectedCaching() {
        Self.cleanup()

        XCTAssert(executionStatusWithCaching == 0)
        XCTAssertNotNil(cacheHash)
    }

    func test6_checkCacheUsing() {
        let oldHash = cacheHash
        XCTAssertNotNil(oldHash)
        XCTAssert(executionStatusWithCaching == 0)

        let newHash = cacheHash
        XCTAssertNotNil(newHash)
        XCTAssertEqual(oldHash, newHash )
    }
}

private extension WorkspaceGenCLITests {
    static func cleanup() {
        try? fixturesXCWorkspaceFolderPath.delete()
        try? cacheDomainPath.delete()
    }

    func executeCLI(useCaching: Bool) -> Int32 {
        let cli = WorkspaceGenCLI()
        let status = cli.execute(
            arguments: [
                "generate",
                fixturesManifestPath.string,
                fixturesPath.string,
                useCaching ? cacheName : nil
            ].compactMap { $0 }
        )

        return status
    }

    var cacheHash: String? {
        guard
            let cacheData = try? cachePath.read(),
            let cacheHash = String(data: cacheData, encoding: .utf8)
        else {
            return nil
        }

        return cacheHash
    }

    var executionStatusWithoutCaching: Int32 {
        executeCLI(useCaching: false)
    }

    var executionStatusWithCaching: Int32 {
        executeCLI(useCaching: true)
    }
}
