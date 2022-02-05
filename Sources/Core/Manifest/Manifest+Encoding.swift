extension Manifest: Encodable {
    fileprivate enum CodingKeys: String, CodingKey {
        case fileRef = "FileRef"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        for kind in WorkspaceElementKind.allCases {
            let workspaceElements = try self.sortedWorkspaceElements
                .filter { $0.kind == kind }

            try container.encode(workspaceElements, forKey: kind.codingKey)
        }
    }
}

extension WorkspaceElementKind {
    fileprivate var codingKey: Manifest.CodingKeys {
        switch self {
        case .fileRef:
            return .fileRef
        }
    }
}
