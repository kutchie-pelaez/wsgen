public struct Manifest: Equatable {
    public static var outputPath: String?

    public let name: String
    public let workspaceElements: [WorkspaceElement]
    let sorting: Sorting
}
