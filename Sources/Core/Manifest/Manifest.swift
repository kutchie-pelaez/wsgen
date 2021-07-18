public struct Manifest {

    public static var outputPath: String?

    // Public
    public let name: String

    // Internal
    let workspaceElements: [WorkspaceElement]
}
