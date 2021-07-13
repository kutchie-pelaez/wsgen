import XMLCoder

public struct WorkspaceXMLGenerator {

    public init(workspacefile: Workspacefile) {
        self.workspacefile = workspacefile
    }

    private let workspacefile: Workspacefile

    public func generateRawStringFromWorkspacefile() throws -> String {
        let encoder = XMLEncoder()
        let header = XMLHeader(
            version: 1.0,
            encoding: "UTF-8"
        )
        let data = try encoder.encode(
            workspacefile,
            withRootKey: "Workspace",
            header: header
        )
        
        guard let string = String(data: data, encoding: .utf8) else {
            throw WorkspaceXMLGeneratorError.invalidXMLData
        }

        return string
    }
}

// MARK: - WorkspaceXMLGeneratorError

public enum WorkspaceXMLGeneratorError: Error {
    case invalidXMLData
}
