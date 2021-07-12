public struct WorkspaceXMLGenerator {

    public init(workspacefile: Workspacefile) {
        self.workspacefile = workspacefile
    }

    private let workspacefile: Workspacefile

    public func generateRawStringFromWorkspacefile() throws -> String {
        ""
    }
}
