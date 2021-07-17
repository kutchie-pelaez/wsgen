import XMLCoder

public struct WorkspaceGenerator {

    public init(manifest: Manifest) {
        self.manifest = manifest
    }

    private let manifest: Manifest

    public func generateXMLString() throws -> String {
        let encoder = XMLEncoder()
        let header = XMLHeader(
            version: 1.0,
            encoding: "UTF-8"
        )
        let data = try encoder.encode(
            manifest,
            withRootKey: "Workspace",
            rootAttributes: [
                "version": "1.0"
            ],
            header: header
        )
        
        guard let string = String(data: data, encoding: .utf8) else {
            throw WorkspaceGeneratorError.invalidXMLData
        }

        return string
    }
}

// MARK: - WorkspaceGeneratorError

public enum WorkspaceGeneratorError: Error {
    case invalidXMLData
}
